#!/bin/bash

# Crear el archivo HTML principal
cat > src/pages/busqueda-vuelos.html << 'EOF'
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Búsqueda de Vuelos - Agencia de Viajes</title>
    <link rel="stylesheet" href="../styles/busqueda-vuelos.css">
</head>
<body>
    <div class="container">
        <h1>Buscar Vuelos ✈️</h1>
        
        <form id="flight-search-form" class="search-form">
            <div class="form-row">
                <div class="form-group">
                    <label for="origin">Ciudad de Origen:</label>
                    <input type="text" id="origin" name="origin" placeholder="Ej: Santiago" required>
                </div>
                
                <div class="form-group">
                    <label for="destination">Ciudad de Destino:</label>
                    <input type="text" id="destination" name="destination" placeholder="Ej: Madrid" required>
                </div>
            </div>
            
            <div class="form-row">
                <div class="form-group">
                    <label for="departure-date">Fecha de Ida:</label>
                    <input type="date" id="departure-date" name="departureDate" required>
                </div>
                
                <div class="form-group">
                    <label for="return-date">Fecha de Vuelta:</label>
                    <input type="date" id="return-date" name="returnDate">
                </div>
            </div>
            
            <div class="form-row">
                <div class="form-group">
                    <label for="passengers">Pasajeros:</label>
                    <select id="passengers" name="passengers">
                        <option value="1">1 Pasajero</option>
                        <option value="2">2 Pasajeros</option>
                        <option value="3">3 Pasajeros</option>
                        <option value="4">4 Pasajeros</option>
                        <option value="5">5+ Pasajeros</option>
                    </select>
                </div>
                
                <div class="form-group">
                    <label for="class">Clase:</label>
                    <select id="class" name="class">
                        <option value="economy">Económica</option>
                        <option value="business">Ejecutiva</option>
                        <option value="first">Primera Clase</option>
                    </select>
                </div>
            </div>
            
            <button type="submit" class="search-button">Buscar Vuelos</button>
        </form>
        
        <div id="results" class="results-container" style="display: none;">
            <h2>Resultados de Búsqueda</h2>
            <div id="flights-list"></div>
        </div>
    </div>
    
    <script src="../components/flightSearch.js"></script>
</body>
</html>
EOF

# Crear el archivo CSS
mkdir -p src/styles
cat > src/styles/busqueda-vuelos.css << 'EOF'
/* Estilos generales */
* {
    margin: 0;
    padding: 0;
    box-sizing: border-box;
}

body {
    font-family: Arial, sans-serif;
    background-color: #f5f5f5;
    color: #333;
}

.container {
    max-width: 800px;
    margin: 0 auto;
    padding: 20px;
}

h1 {
    text-align: center;
    color: #2c3e50;
    margin-bottom: 30px;
}

/* Formulario de búsqueda */
.search-form {
    background: white;
    padding: 30px;
    border-radius: 10px;
    box-shadow: 0 2px 10px rgba(0,0,0,0.1);
}

.form-row {
    display: flex;
    gap: 20px;
    margin-bottom: 20px;
}

.form-group {
    flex: 1;
}

.form-group label {
    display: block;
    margin-bottom: 5px;
    font-weight: bold;
    color: #555;
}

.form-group input,
.form-group select {
    width: 100%;
    padding: 10px;
    border: 1px solid #ddd;
    border-radius: 5px;
    font-size: 16px;
}

.form-group input:focus,
.form-group select:focus {
    outline: none;
    border-color: #3498db;
}

.search-button {
    width: 100%;
    padding: 15px;
    background-color: #3498db;
    color: white;
    border: none;
    border-radius: 5px;
    font-size: 18px;
    font-weight: bold;
    cursor: pointer;
    transition: background-color 0.3s;
}

.search-button:hover {
    background-color: #2980b9;
}

/* Resultados */
.results-container {
    margin-top: 30px;
}

.flight-card {
    background: white;
    padding: 20px;
    margin-bottom: 15px;
    border-radius: 8px;
    box-shadow: 0 2px 5px rgba(0,0,0,0.1);
    display: flex;
    justify-content: space-between;
    align-items: center;
}

.flight-info h3 {
    color: #2c3e50;
    margin-bottom: 10px;
}

.flight-price {
    text-align: right;
}

.price {
    font-size: 24px;
    font-weight: bold;
    color: #27ae60;
}

.select-button {
    margin-top: 10px;
    padding: 10px 20px;
    background-color: #27ae60;
    color: white;
    border: none;
    border-radius: 5px;
    cursor: pointer;
}

.select-button:hover {
    background-color: #229954;
}

/* Responsive */
@media (max-width: 600px) {
    .form-row {
        flex-direction: column;
    }
    
    .flight-card {
        flex-direction: column;
        text-align: center;
    }
    
    .flight-price {
        margin-top: 15px;
    }
}
EOF

# Crear el archivo JavaScript
cat > src/components/flightSearch.js << 'EOF'
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
EOF

# Crear el servicio de vuelos
cat > src/services/flightService.js << 'EOF'
// flightService.js - Servicio para gestionar vuelos

class FlightService {
    constructor() {
        this.apiUrl = process.env.API_URL || 'http://localhost:3000/api';
    }
    
    // Buscar vuelos disponibles
    async searchFlights(searchParams) {
        try {
            const queryString = new URLSearchParams(searchParams).toString();
            const response = await fetch(`${this.apiUrl}/flights/search?${queryString}`);
            
            if (!response.ok) {
                throw new Error('Error al buscar vuelos');
            }
            
            return await response.json();
        } catch (error) {
            console.error('Error en búsqueda de vuelos:', error);
            throw error;
        }
    }
    
    // Obtener detalles de un vuelo
    async getFlightDetails(flightId) {
        try {
            const response = await fetch(`${this.apiUrl}/flights/${flightId}`);
            
            if (!response.ok) {
                throw new Error('Vuelo no encontrado');
            }
            
            return await response.json();
        } catch (error) {
            console.error('Error al obtener detalles del vuelo:', error);
            throw error;
        }
    }
    
    // Verificar disponibilidad
    async checkAvailability(flightId, passengers) {
        try {
            const response = await fetch(`${this.apiUrl}/flights/${flightId}/availability`, {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/json'
                },
                body: JSON.stringify({ passengers })
            });
            
            return await response.json();
        } catch (error) {
            console.error('Error al verificar disponibilidad:', error);
            throw error;
        }
    }
}

// Exportar para uso en otros módulos
if (typeof module !== 'undefined' && module.exports) {
    module.exports = FlightService;
}
EOF

echo "✅ Archivos de búsqueda de vuelos creados con éxito!"
