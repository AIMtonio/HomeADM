-- COINCIDEREMESASUSUSERACT
DELIMITER ;
DROP PROCEDURE IF EXISTS `COINCIDEREMESASUSUSERACT`;

DELIMITER $$
CREATE PROCEDURE `COINCIDEREMESASUSUSERACT`(
-- Stored procedure para actualizar los usuarios de servicios a los que se les encotró coincidencia.
	Par_UsuarioServicioID   INT(11),			    -- Parámetro identificador del usuario de servicio.
	Par_NumAct			    TINYINT UNSIGNED,	    -- Parámetro número de actualización que se realizará.

    Par_Salida          	CHAR(1),				-- Parámetro de salida S=si, N=no.
    INOUT Par_NumErr    	INT(11),				-- Parámetro de salida número de error.
    INOUT Par_ErrMen    	VARCHAR(400),			-- Parámetro de salida mensaje de error.

    Aud_EmpresaID         	INT(11),				-- Parámetro de auditoría ID de la empresa.
	Aud_Usuario         	INT(11),				-- Parámetro de auditoría ID del usuario.
	Aud_FechaActual     	DATETIME,				-- Parámetro de auditoría fecha actual.
	Aud_DireccionIP     	VARCHAR(15),			-- Parámetro de auditoría direccion IP.
	Aud_ProgramaID      	VARCHAR(50),			-- Parámetro de auditoría programa.
	Aud_Sucursal        	INT(11),				-- Parámetro de auditoría ID de la sucursal.
	Aud_NumTransaccion  	BIGINT(20)				-- Parámetro de auditoría numero de transaccion.
)
TerminaStore: BEGIN

    -- Declaracion de variables
    DECLARE Var_Control             VARCHAR(50);    -- Variable para control de errores.
    DECLARE Var_UsuarioServicioID   INT;            -- Variable para el id del usuario

	-- Declaracion de Constantes
    DECLARE	Cadena_Vacia	        CHAR(1);		-- Constante cadena vacia ''.
	DECLARE	Fecha_Vacia		        DATE;			-- Constante fecha vacia 1900-01-01.
	DECLARE	Entero_Cero		        INT;		    -- Constante numero cero (0).
    DECLARE Act_Unificar            INT;            -- Actualización para marcar como unificado usuarios que son coincidencias.
    DECLARE Cons_Si                 CHAR(1);        -- Constante si 'S'

	-- Asignacion de Constantes
    SET Cadena_Vacia    := '';
    SET Fecha_Vacia     := '1900-01-01';
    SET Entero_Cero     := 0;
    SET Act_Unificar    := 1;
    SET Cons_Si         := 'S';


    ManejoErrores:BEGIN

        DECLARE EXIT HANDLER FOR SQLEXCEPTION BEGIN
			SET Par_NumErr  := 999;
			SET Par_ErrMen  := CONCAT('El SAFI ha tenido un problema al concretar la operacion. Disculpe las molestias que ',
										'esto le ocasiona. Ref: SP-COINCIDEREMESASUSUSERACT');
			SET Var_Control := 'SQLEXCEPTION';
		END;

        -- 1.- Actualización para marcar como unificado los usuarios que fueron agregados como coincidencias.
        IF (Par_NumAct = Act_Unificar) THEN

            IF (IFNULL(Par_UsuarioServicioID, Entero_Cero) = Cadena_Vacia) THEN
                SET Par_NumErr		:= 1;
			    SET Par_ErrMen		:= 'El identificador del usuario de servicios esta vacio.';
			    SET	Var_Control		:= Cadena_Vacia;
                LEAVE ManejoErrores;
            END IF;

            SET Var_UsuarioServicioID := (SELECT UsuarioServCoinID FROM COINCIDEREMESASUSUSER WHERE UsuarioServCoinID = Par_UsuarioServicioID LIMIT 1);

            IF (IFNULL(Var_UsuarioServicioID, Entero_Cero) = Entero_Cero) THEN
                SET Par_NumErr		:= 2;
			    SET Par_ErrMen		:= 'El identificador del usuario de servicios no existe.';
			    SET	Var_Control		:= Cadena_Vacia;
                LEAVE ManejoErrores;
            END IF;

            UPDATE COINCIDEREMESASUSUSER
            SET Unificado       = Cons_Si,
                empresaID       = Aud_EmpresaID,
                Usuario			= Aud_Usuario,
			    FechaActual		= Aud_FechaActual,
			    DireccionIP		= Aud_DireccionIP,
			    ProgramaID		= Aud_ProgramaID,
			    Sucursal		= Aud_Sucursal,
			    NumTransaccion  = Aud_NumTransaccion
            WHERE UsuarioServCoinID = Par_UsuarioServicioID;

            SET Par_NumErr := Entero_Cero;
			SET Par_ErrMen := CONCAT("Usuario de servicios unificado correctamente: ", Par_UsuarioServicioID);
			SET Var_Control  := 'usuarioID';

        END IF;

    END ManejoErrores;

	IF (Par_Salida = Cons_Si) THEN
		SELECT 	Par_NumErr 		AS NumErr,
				Par_ErrMen 		AS ErrMen,
				Var_Control 	AS Control,
                Entero_Cero 	AS Consecutivo;
    END IF;

END TerminaStore$$
