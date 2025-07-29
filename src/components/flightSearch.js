// flightSearch.js - Lógica de búsqueda de vuelos

document.addEventListener('DOMContentLoaded', function() {
    const form = document.getElementById('flight-search-form');
    const resultsContainer = document.getElementById('results');
    const flightsList = document.getElementById('flights-list');
    
    // Establecer fecha mínima como hoy
    const today = new Date().toISOString().split('T')[0];
    document.getElementById('departure-date').setAttribute('min', today);
    document.getElementById('return-date').setAttribute('min', today);
    
    // Manejar el envío del formulario
    form.addEventListener('submit', async function(e) {
        e.preventDefault();
        
        // Obtener valores del formulario
        const formData = {
            origin: document.getElementById('origin').value,
            destination: document.getElementById('destination').value,
            departureDate: document.getElementById('departure-date').value,
            returnDate: document.getElementById('return-date').value,
            passengers: document.getElementById('passengers').value,
            class: document.getElementById('class').value
        };
        
        // Mostrar mensaje de búsqueda
        flightsList.innerHTML = '<p>Buscando vuelos disponibles...</p>';
        resultsContainer.style.display = 'block';
        
        // Simular búsqueda de vuelos (en producción, esto sería una llamada a API)
        setTimeout(() => {
            const flights = generateMockFlights(formData);
            displayFlights(flights);
        }, 1500);
    });
    
    // Generar vuelos de prueba
    function generateMockFlights(searchData) {
        const airlines = ['LATAM', 'Avianca', 'Copa Airlines', 'Sky Airline', 'JetSMART'];
        const flights = [];
        
        for (let i = 0; i < 5; i++) {
            flights.push({
                id: `FL00${i + 1}`,
                airline: airlines[i],
                origin: searchData.origin,
                destination: searchData.destination,
                departureTime: generateRandomTime(),
                arrivalTime: generateRandomTime(),
                price: Math.floor(Math.random() * 500) + 200,
                class: searchData.class,
                available: Math.random() > 0.2
            });
        }
        
        return flights;
    }
    
    // Generar hora aleatoria
    function generateRandomTime() {
        const hour = Math.floor(Math.random() * 24);
        const minute = Math.floor(Math.random() * 60);
        return `${hour.toString().padStart(2, '0')}:${minute.toString().padStart(2, '0')}`;
    }
    
    // Mostrar vuelos en la página
    function displayFlights(flights) {
        flightsList.innerHTML = '';
        
        if (flights.length === 0) {
            flightsList.innerHTML = '<p>No se encontraron vuelos disponibles.</p>';
            return;
        }
        
        flights.forEach(flight => {
            const flightCard = document.createElement('div');
            flightCard.className = 'flight-card';
            
            flightCard.innerHTML = `
                <div class="flight-info">
                    <h3>${flight.airline} - ${flight.id}</h3>
                    <p><strong>${flight.origin}</strong> → <strong>${flight.destination}</strong></p>
                    <p>Salida: ${flight.departureTime} - Llegada: ${flight.arrivalTime}</p>
                    <p>Clase: ${getClassName(flight.class)}</p>
                    <p>Estado: ${flight.available ? '✅ Disponible' : '❌ Agotado'}</p>
                </div>
                <div class="flight-price">
                    <div class="price">$${flight.price} USD</div>
                    <button class="select-button" ${!flight.available ? 'disabled' : ''} 
                            onclick="selectFlight('${flight.id}')">
                        ${flight.available ? 'Seleccionar' : 'No disponible'}
                    </button>
                </div>
            `;
            
            flightsList.appendChild(flightCard);
        });
    }
    
    // Obtener nombre de clase en español
    function getClassName(classCode) {
        const classes = {
            'economy': 'Económica',
            'business': 'Ejecutiva',
            'first': 'Primera Clase'
        };
        return classes[classCode] || classCode;
    }
});

// Función para seleccionar vuelo
function selectFlight(flightId) {
    alert(`Has seleccionado el vuelo ${flightId}. ¡Redirigiendo a la página de reserva!`);
    // Aquí iría la lógica para continuar con la reserva
}
