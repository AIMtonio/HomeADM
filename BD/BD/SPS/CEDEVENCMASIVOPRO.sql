-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- CEDEVENCMASIVOPRO
DELIMITER ;
DROP PROCEDURE IF EXISTS `CEDEVENCMASIVOPRO`;DELIMITER $$

CREATE PROCEDURE `CEDEVENCMASIVOPRO`(
# ====================================================================
# -------- SP PARA REGISTRAR EL VENCIMIENTO MASIVO DE LOS CEDES-------
# ====================================================================
    Par_Fecha           DATE,

    Par_Salida          CHAR(1),
    INOUT Par_NumErr    INT(11),
    INOUT Par_ErrMen    VARCHAR(400),
    Par_EmpresaID       INT(11),

    Aud_Usuario         INT(11),
    Aud_FechaActual     DATETIME,
    Aud_DireccionIP     VARCHAR(15),
    Aud_ProgramaID      VARCHAR(50),
    Aud_Sucursal        INT(11),
    Aud_NumTransaccion  BIGINT(20)
)
TerminaStore: BEGIN

	-- Declaracion de Variables
	DECLARE Var_MinutosBit      INT(11);        -- Almacena los minutos que que duro el proceso
	DECLARE Var_FechaProceso    DATE;           -- Almacena la fecha que se obtiene de la tabla BITACORACEDEVENMAS
	DECLARE Var_TotalRegistros  INT(11);        -- Almacena el total de registros que se procesan en el vencimiento masivo
	DECLARE Var_TotalExitos     INT(11);        -- Almacena el total de registros exitosos procesados
	DECLARE Num_CedesVence      INT(11);        -- Almacena el total de cedes que se encuentran para vencer
	DECLARE Var_FechaPro        DATETIME;       -- Almacena la fecha que se guardara en la tabla BITACORACEDEVENMAS
	DECLARE Var_ContUnoTotal    INT(11);        -- Contador total CEDEPAGOCIERREPRO vencimiento masivo cedes
	DECLARE Var_ContUnoExito    INT(11);        -- Contador exito CEDEPAGOCIERREPRO vencimiento masivo cedes
	DECLARE Var_ContDosTotal    INT(11);        -- Contador total CEDEMASIVOPRO vencimiento masivo cedes
	DECLARE Var_ContDosExito    INT(11);        -- Contador exito CEDEMASIVOPRO vencimiento masivo cedes
	DECLARE Var_CliProEsp	  	INT;

	-- Declaracion de Constantes
	DECLARE Fecha_Vacia         DATE;           -- Fecha vacia
	DECLARE Entero_Cero         INT(11);        -- Entero cero
	DECLARE Salida_NO           CHAR(1);        -- Parametro salida NO
	DECLARE Salida_SI           CHAR(1);        -- Parametro salida SI
	DECLARE Cede_Vigente        CHAR(1);        -- Cede Vigente
	DECLARE Pago_NoReinversion	CHAR(1);        -- No reinvertir
	DECLARE ProcesoPantalla     CHAR(1);
	DECLARE NoCliEsp		 	INT;
    	DECLARE CliProcEspecifico 	VARCHAR(20);

	-- Asignacion de Constantes
	SET Fecha_Vacia         	:= '1900-01-01';-- Fecha vacia
	SET Entero_Cero         	:= 0;           -- Entero cero
	SET Salida_NO           	:= 'N';         -- Parametro salida NO
	SET Salida_SI           	:= 'S';         -- Parametro salida SI
	SET Cede_Vigente        	:= 'N';         -- Estatus CEDE: Vigente
	SET Pago_NoReinversion  	:= 'N';         -- No reinvertir
	SET ProcesoPantalla     	:= 'P';
	SET NoCliEsp				:=24;				-- Cliente CrediClub
	SET CliProcEspecifico		:='CliProcEspecifico';

    ManejoErrores : BEGIN

		DECLARE EXIT HANDLER FOR SQLEXCEPTION
			BEGIN
				SET Par_NumErr = 999;
				SET Par_ErrMen = CONCAT('El SAFI ha tenido un problema al concretar la operacion.Disculpe las molestias que ',
										  'esto le ocasiona. Ref: SP-CEDEVENCMASIVOPRO');

			END;

		-- Seteo de la fecha actual, a la fecha de auditoria
		SET Aud_FechaActual := NOW();
		-- Seteo de la fecha que se pasa como parametro
		-- con la hora para la bitacora del proceso que guarda la cantida de registros procesados
		SET Var_FechaPro := CONVERT(CONCAT(Par_Fecha,":",CURRENT_TIME),DATETIME);

		-- Se obtiene la fecha del proceso que se guardado en la bitacora de
		-- vencimiento masivo de cedes BITACORACEDEVENMAS en base a la fecha que se pasa como parametro
		SELECT DATE(FechaProceso) INTO Var_FechaProceso
			FROM 	BITACORACEDEVENMAS
			WHERE 	DATE(FechaProceso)	= Par_Fecha;

			-- Verifica si hay cedes que vencen en el dia que se realiza el proceso
		SELECT COUNT(c. CedeID) INTO Num_CedesVence
			FROM 	CEDES c
					INNER JOIN AMORTIZACEDES a ON c.CedeID = a.CedeID
			WHERE 	a.FechaPago	= Par_Fecha
            AND 	a.Estatus	= Cede_Vigente;


		SELECT ValorParametro INTO Var_CliProEsp
			FROM PARAMGENERALES
			WHERE LlaveParametro= CliProcEspecifico;

		-- Si la fecha del proceso (tabla BITACORACEDEVENMAS) es igual a la fecha actual
		-- entonces el porceso ya fue ejecutado y no podra volverse a ejecutar para la misma fecha
		IF(Var_FechaProceso = Par_Fecha) THEN
			SET Par_NumErr	:= 1;
			SET Par_ErrMen 	:= 'No es Posible Ejecutar el Proceso. Los movimientos ya Fueron Procesados.';
			LEAVE ManejoErrores;
		END IF;

		-- Si no existen cedes que se vensan en el dia que se pasa como parametro
		-- se manda un mensaje de validacion en pantalla.
		IF(Num_CedesVence = Entero_Cero) THEN
			SET Par_NumErr	:= 2;
			SET Par_ErrMen 	:= 'No existen CEDES por vencer o CEDES por entregar intereses.';
			LEAVE ManejoErrores;
		END IF;
		IF (Var_CliProEsp = NoCliEsp) THEN
			CALL CEDEPAGOCIERREPRO024(
				Par_Fecha,          ProcesoPantalla,    Pago_NoReinversion, Salida_NO,          Par_NumErr,
				Par_ErrMen,         Var_ContUnoTotal,   Var_ContUnoExito,   Par_EmpresaID,      Aud_Usuario,
				Aud_FechaActual,    Aud_DireccionIP,    Aud_ProgramaID,     Aud_Sucursal,       Aud_NumTransaccion);
        ELSE
			CALL CEDEPAGOCIERREPRO(
				Par_Fecha,          ProcesoPantalla,    Pago_NoReinversion, Salida_NO,          Par_NumErr,
				Par_ErrMen,         Var_ContUnoTotal,   Var_ContUnoExito,   Par_EmpresaID,      Aud_Usuario,
				Aud_FechaActual,    Aud_DireccionIP,    Aud_ProgramaID,     Aud_Sucursal,       Aud_NumTransaccion);
		END IF;

		IF(Par_NumErr != Entero_Cero) THEN
			LEAVE ManejoErrores;
		END IF;

		-- VENCIMIENTO MASIVO Y PAGO DE CEDES QUE SI SE REINVIERTEN AUTOMATICAMENTE
		CALL CEDEMASIVOPRO(
			Par_Fecha,          ProcesoPantalla,    Par_NumErr,     Par_ErrMen,         Salida_NO,
			Var_ContDosTotal,   Var_ContDosExito,   Par_EmpresaID,  Aud_Usuario,        Aud_FechaActual,
			Aud_DireccionIP,    Aud_ProgramaID,     Aud_Sucursal,   Aud_NumTransaccion);

		IF(Par_NumErr != Entero_Cero) THEN
			LEAVE ManejoErrores;
		END IF;

		-- Se obtiene el total de registros que se procesan
		SET Var_TotalRegistros  := IFNULL(Var_ContUnoTotal,Entero_Cero)+ IFNULL(Var_ContDosTotal,Entero_Cero);
		SET Var_TotalExitos     := IFNULL(Var_ContUnoExito,Entero_Cero)+ IFNULL(Var_ContDosExito,Entero_Cero);

		-- Se obtiene los minutos que guardara la tabla BITACORACEDEVENMAS
		SET Var_MinutosBit := TIMESTAMPDIFF(MINUTE, Var_FechaPro, NOW());

		-- Se inserta en la tabla BITACORACEDEVENMAS, el numero de registros procesados
		INSERT INTO BITACORACEDEVENMAS (
			FechaProceso,       Tiempo,             UsuarioProceso,     NumRegistros,           Exitos,
			EmpresaID,          Usuario,            FechaActual,        DireccionIP,            ProgramaID,
			Sucursal,           NumTransaccion)
		VALUES(
			Var_FechaPro,       Var_MinutosBit,     Aud_Usuario,        Var_TotalRegistros,     Var_TotalExitos,
			Par_EmpresaID,      Aud_Usuario,        Aud_FechaActual,    Aud_DireccionIP,        Aud_ProgramaID,
			Aud_Sucursal,       Aud_NumTransaccion);

		SET Par_NumErr  :=  0;
		SET Par_ErrMen  :=  CONCAT('Vencimiento Masivo Realizado Exitosamente. ',Var_TotalExitos,' Registro(s) Procesado(s).');

	END ManejoErrores;

	IF(Par_Salida = Salida_SI) THEN
		SELECT  Par_NumErr  AS NumErr,
				Par_ErrMen  AS ErrMen,
				Entero_Cero AS Consecutivo,
				Entero_Cero AS Control;
	END IF;

END TerminaStore$$