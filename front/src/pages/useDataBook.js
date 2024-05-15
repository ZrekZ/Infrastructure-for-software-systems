import React, { useContext, createContext, useState } from "react";

const MapBookContext = createContext();

export const MapBookProvider = ({children}) => {
    const[get, set] = useState([]);

    return (
        <MapBookContext.Provider value={{get, set}}>
            {children}
        </MapBookContext.Provider>
    );
}

export const useBooks = () => useContext(MapBookContext);