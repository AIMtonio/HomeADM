-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- NIVELPRUDENOPERAINSPRO
DELIMITER ;
DROP PROCEDURE IF EXISTS `NIVELPRUDENOPERAINSPRO`;DELIMITER $$

CREATE PROCEDURE `NIVELPRUDENOPERAINSPRO`(
# ==================================================================
# -- SP QUE REGISTRA/ACTUALIZA CLAVE DE NIV. OPE. PRU POR PERIODO----
# ==================================================================
    Par_ClaveNivInstitucion VARCHAR(6),         -- Clave de Nivel de Institucion para el catalogo minimo

    Par_Salida              CHAR(1),        	-- Parametro Par_Salida
    INOUT Par_NumErr        INT(11),        	-- Parametro Par_NumErr
    INOUT Par_ErrMen        VARCHAR(400),  	 	-- Parametro Par_ErrMen

    Par_EmpresaID       	INT(11),			-- Empresa ID
    Aud_Usuario         	INT(11),            -- Usuario ID
    Aud_FechaActual     	DATETIME,           -- Fecha Actual
    Aud_DireccionIP     	VARCHAR(15),        -- Direccion IP
    Aud_ProgramaID      	VARCHAR(50),        -- Programa ID
    Aud_Sucursal        	INT(11),            -- Sucursal ID
    Aud_NumTransaccion		BIGINT(20)          -- Numero de transaccion
)
TerminaStore:BEGIN
	-- Variables
	DECLARE Var_FechaSis		DATE;			-- Fecha actual del sistema
	DECLARE Var_Anio 			INT(11);		-- ano en que se registro la clave
    DECLARE Var_Mes 			INT(11);		-- Mes en que se registro la clave
    DECLARE Var_ClaveNivelEnti	VARCHAR(6);		-- variable que guarda el nivel de la entidad
	DECLARE Var_Consecutivo     INT(11);    	-- Variable consecutivo
    DECLARE Var_Control			VARCHAR(100);	-- Varaibel de control
	DECLARE Var_FechaPeriodo	DATE;

	-- Constantes
	DECLARE Cadena_Vacia    CHAR(1);    		-- Constante de cadena vacia
    DECLARE Fecha_Vacia     DATE;       		-- Constante de Fecha vacia
    DECLARE Entero_Cero     INT(11);    		-- Constante de Entero cero
    DECLARE Entero_Uno     	INT(11);    		-- Constante de Entero 1
    DECLARE SalidaSi        CHAR(1);    		-- Constante salida si
    DECLARE SalidaNo        CHAR(1);    		-- Constante salida no

	-- Asignacion de constantes
	SET Cadena_Vacia            := '';
    SET Fecha_Vacia             := '1900-01-01';
    SET Entero_Cero             := 0;
    SET Entero_Uno				:= 1;
    SET SalidaSi                := 'S';
    SET SalidaNo                := 'N';

	ManejoErrores: BEGIN

	DECLARE EXIT HANDLER FOR SQLEXCEPTION
	BEGIN
		SET Par_NumErr  := 999;
		SET Par_ErrMen  := CONCAT('El SAFI ha tenido un problema al concretar la operacion. ',
								'Disculpe las molestias que esto le ocasiona. Ref: SP-NIVELPRUDENOPERAINSPRO');
		SET Var_Control := 'SQLEXCEPTION' ;
	END;

    -- Se asigna la fehca del sistema y se obtienen los valores mes y ano
    SET Var_FechaSis := (SELECT IFNULL(FechaSistema,Fecha_Vacia) FROM PARAMETROSSIS
										WHERE EmpresaID = Par_EmpresaID);
    SET Var_Anio := YEAR(Var_FechaSis);

	SET Var_Mes := MONTH(Var_FechaSis);

    -- la clave con ano y mes obtenidos
    SET Var_ClaveNivelEnti := (SELECT ClaveNivInstitucion FROM NIVELPRUDENOPERAINS
										WHERE Anio = Var_Anio
											AND Mes = Var_Mes);

	SET Var_ClaveNivelEnti:= IFNULL(Var_ClaveNivelEnti,Cadena_Vacia);

    SET Var_Consecutivo := (SELECT (COUNT(*)+Entero_Uno) FROM NIVELPRUDENOPERAINS);

    SET Var_Consecutivo = IFNULL(Var_Consecutivo,Entero_Uno);

    SET Var_FechaPeriodo   := CONCAT(Var_Anio,'-',Var_Mes,'-','01');

	IF(Var_ClaveNivelEnti = Cadena_Vacia)THEN

		INSERT INTO NIVELPRUDENOPERAINS(
			NivelPrudOperaID,		Anio, 			Mes, 					ClaveNivInstitucion, 	FechaPeriodo,
            EmpresaID, 				Usuario, 		FechaActual, 			DireccionIP, 			ProgramaID,
            Sucursal, 			    NumTransaccion)
        VALUES(
			Var_Consecutivo,	Var_Anio,			Var_Mes,				Par_ClaveNivInstitucion, 	Var_FechaPeriodo,
            Par_EmpresaID,  	Aud_Usuario,      	Aud_FechaActual,    	Aud_DireccionIP,			Aud_ProgramaID,
            Aud_Sucursal,		Aud_NumTransaccion);
	ELSE
		IF(Var_ClaveNivelEnti <> Par_ClaveNivInstitucion)THEN

            UPDATE NIVELPRUDENOPERAINS SET
				ClaveNivInstitucion     = Par_ClaveNivInstitucion,
				EmpresaID				= Par_EmpresaID,
				Usuario                 = Aud_Usuario,
				FechaActual             = Aud_FechaActual,
				DireccionIP             = Aud_DireccionIP,
				ProgramaID              = Aud_ProgramaID,
				Sucursal                = Aud_Sucursal,
				NumTransaccion          = Aud_NumTransaccion
			WHERE Anio = Var_Anio
				AND Mes = Var_Mes;
        END IF;
	END IF;

	SET Par_NumErr  	:= Entero_Cero;
	SET Par_ErrMen  	:= 'Operacion Realizada Exitosamente';
	SET Var_Control 	:= 'claveNivInstitucion';

	END ManejoErrores;

		IF(Par_Salida = SalidaSi) THEN
			SELECT  Par_NumErr AS NumErr,
					Par_ErrMen AS ErrMen,
					Var_Control AS Control,
					Var_Consecutivo AS Consecutivo;
		END IF;

END TerminaStore$$