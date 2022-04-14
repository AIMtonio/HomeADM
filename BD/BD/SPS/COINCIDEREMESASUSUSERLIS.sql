-- COINCIDEREMESASUSUSERLIS
DELIMITER ;
DROP PROCEDURE IF EXISTS `COINCIDEREMESASUSUSERLIS`;

DELIMITER $$
CREATE PROCEDURE `COINCIDEREMESASUSUSERLIS`(
-- Stored procedure para listar las oincidencias de usuarios de servicios.
    Par_UsuarioServicioID   INT(11),                -- Parámetro identificador del usuario de servicios
    Par_NumLis              TINYINT UNSIGNED,       -- Parámetro número de lista

    Aud_EmpresaID         	INT(11),				-- Parámetro de auditoría ID de la empresa.
	Aud_Usuario         	INT(11),				-- Parámetro de auditoría ID del usuario.
	Aud_FechaActual     	DATETIME,				-- Parámetro de auditoría fecha actual.
	Aud_DireccionIP     	VARCHAR(15),			-- Parámetro de auditoría direccion IP.
	Aud_ProgramaID      	VARCHAR(50),			-- Parámetro de auditoría programa.
	Aud_Sucursal        	INT(11),				-- Parámetro de auditoría ID de la sucursal.
	Aud_NumTransaccion  	BIGINT(20)				-- Parámetro de auditoría numero de transaccion.
)

TerminaStore: BEGIN

    -- Declaración de constantes.
    DECLARE	Cadena_Vacia	    CHAR(1);		-- Constante cadena vacia ''.
	DECLARE	Fecha_Vacia		    DATE;			-- Constante fecha vacia 1900-01-01.
	DECLARE	Entero_Cero		    INT;		    -- Constante numero cero (0).
    DECLARE Cons_NO             CHAR(1);        -- Constante NO 'N'
    DECLARE Lis_Coincidencias   INT;            -- Lista de usuarios con coincidencia

    -- Asignación de constantes
    SET Cadena_Vacia        := '';
    SET Fecha_Vacia         := '1900-01-01';
    SET Entero_Cero         := 0;
    SET Cons_NO             := 'N';
    SET Lis_Coincidencias   := 4;


    -- Lista coincidencias: Usuarios de servicios que tienen coincidencia con otro usuario
    -- Pantalla: Ventanilla > Registro > Unificar Usuario Servicios.
    IF(Par_NumLis = Lis_Coincidencias) THEN

        SELECT UsuarioServCoinID,   NombreCompletoCoin, RFCCoin,    CURPCoin,   PorcConcidencia
        FROM COINCIDEREMESASUSUSER
        WHERE UsuarioServicioID = Par_UsuarioServicioID
        AND Unificado = Cons_NO;
    END IF;

END TerminaStore$$