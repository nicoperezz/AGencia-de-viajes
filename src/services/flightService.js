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
