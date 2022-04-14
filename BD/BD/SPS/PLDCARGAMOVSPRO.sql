-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- PLDCARGAMOVSPRO
DELIMITER ;
DROP PROCEDURE IF EXISTS `PLDCARGAMOVSPRO`;
DELIMITER $$


CREATE PROCEDURE `PLDCARGAMOVSPRO`(
	-- Procedimiento almacenado para realizar la carga de movimeinto pasando por los procesos de PLD
	Par_CargaID					BIGINT(20),				-- Numero de la carga
	Par_PIDTarea				VARCHAR(50),			-- Numero de PIDTarea
	Par_ArchivoMovs				MEDIUMTEXT,				-- Cadena con los movimientos de los clientes

	Par_Salida					CHAR(1),				-- Parametro indicador de la salida
	INOUT Par_NumErr			INT(11),				-- Parametro indicador del numero de error
	INOUT Par_ErrMen			VARCHAR(400),			-- Parametro indicador del mensaje de error

	Aud_EmpresaID				INT(11),				-- Parametro de auditoria
	Aud_Usuario					INT(11),				-- Parametro de auditoria
	Aud_FechaActual				DATETIME,				-- Parametro de auditoria
	Aud_DireccionIP				VARCHAR(15),			-- Parametro de auditoria
	Aud_ProgramaID				VARCHAR(50),			-- Parametro de auditoria
	Aud_Sucursal				INT(11),				-- Parametro de auditoria
	Aud_NumTransaccion			BIGINT(20)				-- Parametro de auditoria
)

TerminaStore: BEGIN

	-- Declaracion de constantes
	DECLARE Entero_Cero				INT(11);				-- Constante entero cero
	DECLARE Cadena_Vacia			CHAR(1);				-- Constante cadena vacia
	DECLARE Salida_SI				CHAR(1);				-- Constante salida si
	DECLARE Salida_NO				CHAR(1);				-- Constante salida si
	DECLARE Fecha_Vacia				DATE;					-- Constante de fecha vacia
	DECLARE Var_Control				VARCHAR(20);			-- Variable de control

	DECLARE Entero_Uno				INT(11);				-- Constante entero uno
	DECLARE Enetro_Dos				INT(11);				-- Constante entero dos
	DECLARE DelimitFinConjunto		CHAR(1);				-- Constante delimitadora del fin del conjunto
	DECLARE Pipe					CHAR(1);				-- Constante contenedora del caracter pipe
	DECLARE Var_Turno				INT(11);				-- Variable indicadora del turno

	DECLARE TurnoCuentaAhoIDClie	INT(11);				-- Varibale indicadora del turno de la cuenta de ahorro
	DECLARE TurnoFecha				INT(11);				-- Variable indicadora de la fecha
	DECLARE TurnoNatMovimiento		INT(11);				-- Variable indicadora de la naturaleza del movimiento
	DECLARE TurnoCantidadMov		INT(11);				-- Variable indicadora de la cantidad de movimiento
	DECLARE TurnoDescripMov			INT(11);				-- Variable indicadora de la descripcion del movimiento

	DECLARE TurnoReferenciaMov		INT(11);				-- Variable indicadora de la referencia del movimiento
	DECLARE TurnoTipoMovAhoID		INT(11);				-- Variable indicadora del tipo movimiento
	DECLARE FinTurnos				INT(11);				-- Variable indicadora  del fin de los turnos
	DECLARE Var_CargaID				BIGINT(20);				-- Variable contenedora del numero de carga
	DECLARE Var_NumRegistros		INT(11);				-- Variable indicadora del numero de registros

	DECLARE Var_CuentaAhoIDClie		VARCHAR(20);			-- Variable contenedora de la cuenta de ahorro del cliente externo
	DECLARE Var_ClienteID			BIGINT(20);				-- Variable contenedora del numero de cliente
	DECLARE Var_Fecha				DATE;					-- Variable contenedora de la fecha
	DECLARE Var_NatMovimiento		CHAR(1);				-- Variable contenedora de la naturaleza del movimiento
	DECLARE Var_CantidadMov			DECIMAL(12,2);			-- Variable contenedora de la cantidad del movimiento

	DECLARE Var_DescripMov			VARCHAR(150);			-- Variable contenedora de la descripcion del movimiento
	DECLARE Var_ReferenciaMov		VARCHAR(50);			-- Variable contenedora de la referencia del movimiento
	DECLARE Var_TipoMovAhoID		CHAR(4);				-- Variable contenedora del tipo de movimiento
	DECLARE Var_EmpresaID			INT(11);				-- Variable contenedora del numero de empresa
	DECLARE Var_Usuario				INT(11);				-- Variable contenedora del numero de usuario

	DECLARE Var_FechaActual			DATETIME;				-- Variable contenedora de la fecha actual
	DECLARE Var_DireccionIP			VARCHAR(15);			-- Variable contenedora de la direccion IP
	DECLARE Var_ProgramaID			VARCHAR(50);			-- Variable contenedora del programa
	DECLARE Var_Sucursal			INT(11);				-- Variable contenedora de la sucursal
	DECLARE Var_NumTransaccion		BIGINT(20);				-- Variable contenedora del numero de transaccion

	DECLARE Var_PosIniConjunto		INT;					-- Variable indicadora de la posicion de inicio del conjunto
	DECLARE Var_PosFinConjunto		INT;					-- Variable indicadora de la posicion de fin del conjunto
	DECLARE Var_Conjunto			VARCHAR(5000);			-- Variable indicadora del conjunto
	DECLARE Var_PosPipe				INT;					-- Variable indicadora del pos pipe

	DECLARE Var_Mensaje				VARCHAR(400);			-- Variable indicadora  del mensaje
	DECLARE Var_Manejo				VARCHAR(10);			-- Variable indicadora del manejo
	DECLARE Var_Detener				VARCHAR(10);			-- Variable indicadora para detener el proceso
	DECLARE Var_Continuar			VARCHAR(10);			-- Variable indicadora para continuar el proceso
	DECLARE Var_EstError			CHAR(1);				-- Variable indicadora del estatus erroneo

	DECLARE Var_EstProcesado		CHAR(1);				-- Variable indicadora del estatus procesado
	DECLARE Var_MensajeProce		VARCHAR(50);			-- Variable indicadora del mensaje de proceso
	DECLARE Var_Ingresos			INT(11);				-- Variable indicadora de los ingresos
	DECLARE Var_TotalReg			INT(11);				-- Variable indicadora del total de registros

	-- Asignacion de constantes
	SET Entero_Cero					:= 0;
	SET Cadena_Vacia				:= '';
	SET Salida_SI					:= 'S';
	SET Salida_NO					:= 'N';
	SET Fecha_Vacia					:= '1900-01-01';
	SET Var_Detener					:= 'DETIENE';

	SET Var_Manejo					:= 'CONTINUA';
	SET Var_EstError				:= 'E';
	SET Var_Ingresos				:= 0;
	SET Var_EstProcesado			:= 'P';
	SET Var_MensajeProce			:= 'PROCESADO EXITOSAMENTE';

	SET Var_NumRegistros			:= 0;
	SET Entero_Uno					:= 1;
	SET Enetro_Dos					:= 2;
	SET DelimitFinConjunto			:= ']';
	SET Pipe						:= '|';

	SET TurnoCuentaAhoIDClie		:= 1;
	SET TurnoFecha					:= 2;
	SET TurnoNatMovimiento			:= 3;
	SET TurnoCantidadMov			:= 4;
	SET TurnoDescripMov				:= 5;

	SET TurnoReferenciaMov			:= 6;
	SET TurnoTipoMovAhoID			:= 7;
	SET FinTurnos					:= 8;

	ManejoErrores: BEGIN

	DECLARE EXIT HANDLER FOR SQLEXCEPTION
		BEGIN
			SET Par_NumErr   := 999;
			SET Par_ErrMen   := CONCAT('El SAFI ha tenido un problema al concretar la operacion. Disculpe las molestias que ',
				'esto le ocasiona. Ref: SP-PLDCARGAMOVSPRO');
			SET Var_Control  := 'SQLEXCEPTION';
		END;

	SET Par_CargaID				:= IFNULL(Par_CargaID,Entero_Cero);
	SET Par_PIDTarea			:= TRIM(IFNULL(Par_PIDTarea,Cadena_Vacia));
	SET Par_ArchivoMovs			:= TRIM(IFNULL(Par_ArchivoMovs,Cadena_Vacia));

	IF(Par_CargaID = Entero_Cero) THEN
		SET Par_NumErr		:= 001;
		SET Par_ErrMen		:= 'El identificador de la carga se encuentra vacio';
		SET Var_Control		:= 'Par_CargaID';
		LEAVE ManejoErrores;
	END IF;

	IF(Par_PIDTarea = Cadena_Vacia) THEN
		SET Par_NumErr		:= 002;
		SET Par_ErrMen		:= 'El valor del PIDTarea se encuentra vacio';
		SET Var_Control		:= 'Par_PIDTarea';
		LEAVE ManejoErrores;
	END IF;

	IF(Par_ArchivoMovs = Cadena_Vacia) THEN
		SET Par_NumErr		:= 003;
		SET Par_ErrMen		:= 'El valor del Archivo contenedor de los movimientos se encuentra vacio';
		SET Var_Control		:= 'Par_ArchivoMovs';
		LEAVE ManejoErrores;
	END IF;

	-- Borramos la tabla temporal
	DELETE FROM TMPPLDCARGAMOVSDET;

	SET Var_PosFinConjunto := Entero_Uno;
	SET Var_PosFinConjunto := (SELECT POSITION(DelimitFinConjunto  IN Par_ArchivoMovs));

	WHILE Var_PosFinConjunto > Entero_Cero DO

			SELECT  RIGHT(LEFT(Par_ArchivoMovs,Var_PosFinConjunto - Entero_Uno),Var_PosFinConjunto - Enetro_Dos) INTO Var_Conjunto ;

			SET Var_Turno	:= Entero_Uno;

			WHILE Var_Conjunto != Cadena_Vacia DO

				SELECT POSITION( Pipe IN Var_Conjunto ) INTO Var_PosPipe;

				CASE Var_Turno

					WHEN TurnoCuentaAhoIDClie THEN
						SELECT CAST(LEFT(Var_Conjunto, Var_PosPipe - Entero_Uno) AS CHAR(20)) INTO Var_CuentaAhoIDClie;
						SELECT RIGHT(Var_Conjunto,LENGTH(Var_Conjunto) - Var_PosPipe) INTO Var_Conjunto;

				    WHEN TurnoFecha THEN
						SELECT CAST(LEFT(Var_Conjunto, Var_PosPipe - Entero_Uno) AS DATE) INTO Var_Fecha;
						SELECT RIGHT(Var_Conjunto,LENGTH(Var_Conjunto) - Var_PosPipe) INTO Var_Conjunto;

				    WHEN TurnoNatMovimiento THEN
						SELECT CAST(LEFT(Var_Conjunto, Var_PosPipe - Entero_Uno) AS CHAR(1)) INTO Var_NatMovimiento;
						SELECT RIGHT(Var_Conjunto,LENGTH(Var_Conjunto) - Var_PosPipe) INTO Var_Conjunto;

				    WHEN TurnoCantidadMov THEN
						SELECT CAST(LEFT(Var_Conjunto, Var_PosPipe - Entero_Uno) AS DECIMAL(12,2))INTO Var_CantidadMov;
						SELECT RIGHT(Var_Conjunto,LENGTH(Var_Conjunto) - Var_PosPipe) INTO Var_Conjunto;

					WHEN TurnoDescripMov THEN
						SELECT CAST(LEFT(Var_Conjunto, Var_PosPipe - Entero_Uno) AS CHAR(150)) INTO Var_DescripMov;
						SELECT RIGHT(Var_Conjunto,LENGTH(Var_Conjunto) - Var_PosPipe) INTO Var_Conjunto;

					WHEN TurnoReferenciaMov THEN
						SELECT CAST(LEFT(Var_Conjunto, Var_PosPipe - Entero_Uno) AS CHAR(50)) INTO Var_ReferenciaMov;
						SELECT RIGHT(Var_Conjunto,LENGTH(Var_Conjunto) - Var_PosPipe) INTO Var_Conjunto;

					WHEN TurnoTipoMovAhoID THEN
						SELECT Var_Conjunto INTO Var_TipoMovAhoID;

						SET Var_Conjunto := Cadena_Vacia;

				END CASE;

				SET Var_Turno := Var_Turno + Entero_Uno;

				IF(Var_Turno = FinTurnos) THEN

					SET Var_NumRegistros := Var_NumRegistros + Entero_Uno;
					SET Var_ClienteID	 := (SELECT Cue.ClienteID FROM CUENTASAHO Cue
												INNER JOIN PLDCUENTASAHO Pld
												ON Pld.CuentaAhoID = Cue.CuentaAhoID
												WHERE Pld.CuentaAhoIDClie = Var_CuentaAhoIDClie);

					INSERT INTO TMPPLDCARGAMOVSDET(
						CargaID,				NumRegistros,				CuentaAhoIDClie,				ClienteID,				Fecha,
						NatMovimiento,			CantidadMov,				DescripMov,						ReferenciaMov,			TipoMovAhoID,
						EmpresaID,				Usuario,					FechaActual,					DireccionIP,			ProgramaID,
						Sucursal,				NumTransaccion
					)
					VALUES (
						Par_CargaID,			Var_NumRegistros,			Var_CuentaAhoIDClie,			Var_ClienteID,			Var_Fecha,
						Var_NatMovimiento,		Var_CantidadMov,			Var_DescripMov,					Var_ReferenciaMov,		Var_TipoMovAhoID,
						Aud_EmpresaID,			Aud_Usuario,				Aud_FechaActual,				Aud_DireccionIP,		Aud_ProgramaID,
						Aud_Sucursal,			Aud_NumTransaccion
					);

				END IF;

			END WHILE;


		SELECT SUBSTRING(Par_ArchivoMovs , Var_PosFinConjunto + Entero_Uno, LENGTH(Par_ArchivoMovs)) INTO Par_ArchivoMovs ;
		SET Var_PosFinConjunto := (SELECT POSITION(DelimitFinConjunto IN Par_ArchivoMovs));

	END WHILE;


	-- Llamamos al SP encargado de validar que la tabla Temporal no contenga registros NULL
	CALL PLDCARGAMOVSVAL(Par_NumErr,Var_Mensaje,Var_Manejo);

	-- Procesamos la respuesta del SP PLDCARGAMOVSVAL para procesar la informacion segun como lo requiera
	IF(Var_Manejo = Var_Detener) THEN

		-- Actualizamos el Estatus y MensajeError en la tabla PLDCARGAMOVSHEAD para indicar el error sucedido
		UPDATE		PLDCARGAMOVSHEAD	SET
					Estatus				= Var_EstError,
					MensajeError		= Var_Mensaje
		WHERE		CargaID 			= Par_CargaID
		AND 		PIDTarea			= Par_PIDTarea;

		-- Eliminamos los registros de la tabla temporal
		DELETE FROM TMPPLDCARGAMOVSDET
		WHERE CargaID = Par_CargaID
		AND NumTransaccion = Aud_NumTransaccion;

		SET	Par_NumErr 	:= 004;
		SET	Par_ErrMen 	:= CONCAT("Los Movimientos No han sido cargados: ", CONVERT(Par_CargaID, CHAR));
		SET Var_Control := 'CargaID';
		LEAVE ManejoErrores;

	END IF;

	-- Contamos el total de registros de la tabla temporal segun la CargaID y el numero de transaccion
	SET Var_TotalReg	:=(SELECT COUNT(CargaID) FROM TMPPLDCARGAMOVSDET WHERE CargaID = Par_CargaID AND NumTransaccion = Aud_NumTransaccion);
	SET Var_TotalReg	:=IFNULL(Var_TotalReg,Entero_Cero);

	IF(Var_TotalReg = Entero_Cero) THEN
		SET Par_NumErr		:= 005;
		SET Par_ErrMen		:= 'No existen registros para procesar en la tabla TMPPLDCARGAMOVSDET';
		SET Var_Control		:= 'Par_ArchivoMovs';
		LEAVE ManejoErrores;
	END IF;

	-- Ciclo while para la extraccion de los datos de la tabla TMPPLDCARGAMOVSDET para transferirlos a la tabla PLDCARGAMOVSDET
	CARGAMOVS: WHILE Var_Ingresos < Var_TotalReg DO

		-- Incrementamos uno el contador
		SET Var_Ingresos = Var_Ingresos + Entero_Uno;

		-- Obtenemos los datos a insertar en las tabla PLDCARGAMOVSDET
		SELECT		CargaID,					CuentaAhoIDClie,			ClienteID,				Fecha,				NatMovimiento,
					CantidadMov,				DescripMov,					ReferenciaMov,			TipoMovAhoID,		EmpresaID,
                    Usuario,					FechaActual,				DireccionIP,			ProgramaID,			Sucursal,
                    NumTransaccion

        INTO		Var_CargaID,				Var_CuentaAhoIDClie,		Var_ClienteID,			Var_Fecha,			Var_NatMovimiento,
					Var_CantidadMov,			Var_DescripMov,				Var_ReferenciaMov,		Var_TipoMovAhoID,	Var_EmpresaID,
					Var_Usuario,				Var_FechaActual,			Var_DireccionIP,		Var_ProgramaID,		Var_Sucursal,
					Var_NumTransaccion
		FROM 	TMPPLDCARGAMOVSDET
		WHERE	CargaID = Par_CargaID
		AND 	NumTransaccion = Aud_NumTransaccion
		AND 	NumRegistros = Var_Ingresos;

		-- Insertamos los datos obtenidos en la tabla de detalle
		INSERT INTO PLDCARGAMOVSDET (
						CargaID,					CuentaAhoIDClie,			ClienteID,				Fecha,				NatMovimiento,
						CantidadMov,				DescripMov,					ReferenciaMov,			TipoMovAhoID,		EmpresaID,
	                    Usuario,					FechaActual,				DireccionIP,			ProgramaID,			Sucursal,
	                    NumTransaccion)
		VALUES (
						Var_CargaID,				Var_CuentaAhoIDClie,		Var_ClienteID,			Var_Fecha,			Var_NatMovimiento,
						Var_CantidadMov,			Var_DescripMov,				Var_ReferenciaMov,		Var_TipoMovAhoID,	Var_EmpresaID,
						Var_Usuario,				Var_FechaActual,			Var_DireccionIP,		Var_ProgramaID,		Var_Sucursal,
						Var_NumTransaccion
	    );

	    CALL CARGOABONOCUENTAPLDPRO(
	    		Var_CuentaAhoIDClie,		Var_ClienteID,			Var_Fecha,				Var_NatMovimiento,		Var_CantidadMov,
	    		Var_DescripMov,				Var_ReferenciaMov,		Var_TipoMovAhoID,		Salida_NO,				Par_NumErr,
	    		Par_ErrMen,					Aud_EmpresaID,			Aud_Usuario,			Aud_FechaActual,		Aud_DireccionIP,
	    		Aud_ProgramaID,				Aud_Sucursal,			Aud_NumTransaccion
	    );

	    IF(Par_NumErr != Entero_Cero) THEN
	    	SET Par_NumErr		:= 006;
			SET Par_ErrMen		:= CONCAT('El Proceso de CARGOABONOCUENTAPLDPRO fallo: ',Par_ErrMen);
			SET Var_Control		:= 'Par_ArchivoMovs';
		LEAVE ManejoErrores;
	    END IF;

	END WHILE CARGAMOVS;

	-- Insertados los datos en la tabla de detalle, eliminamos los registros de la tabla temporal
	DELETE FROM TMPPLDCARGAMOVSDET
	WHERE CargaID = Par_CargaID
	AND NumTransaccion = Aud_NumTransaccion;

	-- Actualizamos las columnas de Estatus y MensajeErr en la tabla PLDCARGAMOVSHEAD
	UPDATE		PLDCARGAMOVSHEAD	SET
					Estatus				= Var_EstProcesado,
					MensajeError		= Var_MensajeProce
		WHERE		CargaID 			= Par_CargaID
		AND 		PIDTarea			= Par_PIDTarea;

	SET	Par_NumErr 	:= 000;
	SET	Par_ErrMen 	:= CONCAT("Los Movimientos han sido cargados exitosamente: ", CONVERT(Par_CargaID, CHAR));
	SET Var_Control := 'CargaID';

END ManejoErrores;

	IF (Par_Salida = Salida_SI) THEN
		SELECT  Par_NumErr AS NumErr,
				Par_ErrMen AS ErrMen,
				Var_Control AS Control;
	END IF;

END TerminaStore$$