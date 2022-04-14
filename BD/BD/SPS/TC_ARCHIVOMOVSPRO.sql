-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- TC_ARCHIVOMOVSPRO
DELIMITER ;
DROP PROCEDURE IF EXISTS `TC_ARCHIVOMOVSPRO`;
DELIMITER $$


CREATE PROCEDURE `TC_ARCHIVOMOVSPRO`(
-- ---------------------------------------------------------------------------------
--  Se encarga de procesar las transacciones de tarjetas de
--  credito que se cargaron con los archivos de transaccion
-- ---------------------------------------------------------------------------------
    Par_NumTranCarga 		BIGINT(20),		-- Numero de transaccion de la carga del archivo

    Par_Salida              CHAR(1),        -- Salida
    INOUT Par_NumErr        INT(11),        -- Salida
    INOUT Par_ErrMen        VARCHAR(400),   -- Salida

    Aud_EmpresaID           INT(11) ,       -- Auditoria
    Aud_Usuario             INT(11),        -- Auditoria
    Aud_FechaActual         DATETIME ,      -- Auditoria
    Aud_DireccionIP         VARCHAR(15) ,   -- Auditoria
    Aud_ProgramaID          VARCHAR(50) ,   -- Auditoria
    Aud_Sucursal            INT(11) ,       -- Auditoria
    Aud_NumTransaccion      BIGINT(20)      -- Auditoria

)

TerminaStore:BEGIN

    DECLARE Var_NumRegistro         INT;            -- Numero de registros cargados
    DECLARE Var_MaxFilas            INT(11);        -- Numero maximo de filas
    DECLARE Var_PosFila             INT(11);        -- Posicion del CURSOR
    DECLARE Var_CountProcesados     INT(11);        -- Contar los procesados
    DECLARE Var_TxtFila             VARCHAR(520);   -- Guarda el contenido de la fila
    DECLARE Var_TxtFecha            VARCHAR(10);    -- Fecha de operacion
    DECLARE Var_TxtTotalAplicar     DECIMAL(16,2);  -- Monto de operacion
    DECLARE Var_DatosTiempoAire     VARCHAR(20);    -- Datos de tiempo aire
    DECLARE Var_SalidaNo            CHAR(1);        -- Indica una salida de datos
	DECLARE Var_SaldoDispoAct       DECIMAL(12,2);  -- Valor del saldo disponible actual
    DECLARE Var_SaldoContable       DECIMAL(12,2);  -- Valor del saldo contable de la cuenta
    DECLARE Var_CodigoResp			VARCHAR(3);		-- Codigo de respuesta
    DECLARE Var_FechaOperacion		VARCHAR(15);			-- Fecha operacion
    DECLARE Var_FechaOperacionPago	VARCHAR(50);	-- Fecha operacion de pago
    DECLARE Var_OrigenPago			CHAR(1);			--  P: Archivo Pagos, T: Archivo Transacciones

    DECLARE Var_FechaReporte        DATE;           -- Fecha del reporte
    DECLARE Var_FechaSistema        DATE;           -- Fecha actual del sistema
    DECLARE Var_HoraReporte         TIME;           -- Hora del reporte
    DECLARE Var_HoraOperacion       TIME;           -- Hora de Operacion
    DECLARE Var_TotalAplicar        DECIMAL(16,2);  -- Total a aplicar
    DECLARE Var_Exitosos            INT(11);            -- Numero de transacciones exitosas de tipo compra
    DECLARE Var_ExitososPago		INT(11);			-- Numero de transacciones exitosas de tipo pago
	DECLARE Var_FallidosPago		INT(11);			-- Numero de transacciones fallidas de tipo pago
    DECLARE Var_Fallidos            INT(11);            -- Numero de transacciones fallidas de tipo compra
    DECLARE Var_NumTransacciones    INT(11);            -- Nuero de transacciones
	DECLARE Var_FechaAplicacion		DATE;				-- Fecha Aplicacion
	
    -- >> Variables archivo
	DECLARE Var_EstatusRegistrado	CHAR(1);			-- Estatus Registrado
	DECLARE Var_EstatusProcesado 	CHAR(1);			-- Estatus Procesado
	DECLARE Var_EstatusCancelado	CHAR(1);			-- Estatus Cancelado
	DECLARE Var_TipoArchivo			CHAR(1);			-- Tipo de Archivo (E = EMI, S = STATS)
	DECLARE Var_ModAutorizacion		INT(11);			-- Modo de autorizacion de la transaccion
    DECLARE Var_Tc_ArchivoMovsID	BIGINT(20);			-- ID de la linea
    DECLARE Var_NumeroTransacc		BIGINT(20);			-- Numero de la transaccion de registro de la suboperacion de pago linea
	DECLARE Var_TarCredMovID		INT(11);			-- Tarjeta credito movimiento id
	DECLARE Var_Cajero				VARCHAR(10);		-- Numero de Cajero o Terminal.


    DECLARE Var_CT              VARCHAR(2);         -- Tipo de operacion
    DECLARE Var_Tarjeta         VARCHAR(50);        -- Numero de tarjeta
    DECLARE Var_NombreNegocio   VARCHAR(50);        -- Nombre del lugar o negocio
    DECLARE Var_Ciudad          VARCHAR(50);        -- Nombre de la ciudad
    DECLARE Var_Pais            VARCHAR(2);         -- Nombre del pais
    DECLARE Var_MCC             VARCHAR(50);        -- Codigo del negocio
    DECLARE Var_Valor           VARCHAR(50);        -- Monto de operacion
    DECLARE Var_Moneda          VARCHAR(50);        -- Codigo de la moneda
    DECLARE Var_Referencia      VARCHAR(50);        -- Referencia de la operacion
    DECLARE Var_FTran           VARCHAR(50);        -- Folio de transaccion
    DECLARE Var_CPD             VARCHAR(6);         -- Fecha Juliana
    DECLARE Var_IRD             VARCHAR(6);         -- Familia asociada al negocio
    DECLARE Var_Comision        VARCHAR(16);        -- Monto de comision
    DECLARE Var_Autorizacion    VARCHAR(16);        -- Numero de Autorizacion
    DECLARE Var_IVA             VARCHAR(16);        -- Monto de IVA
    DECLARE Var_CuentaClave		CHAR(18);	     	--  Numero de Cuenta Clabe de la Tarjeta de Credito
	DECLARE Var_DescOperacion	VARCHAR(10);
    DECLARE Var_CantOperaciones	INT(11);			-- Variable para el catidad de operaciones
    
    DECLARE Var_Naturaleza      VARCHAR(10);        -- Naturaleza del movimiento
    DECLARE Var_TipoTransaccion	VARCHAR(50);		-- Tipo Transaccion
    DECLARE Var_Registro        VARCHAR(520);       -- REgistro con el contenido del archivo
    DECLARE Error_Key			INT(11);			-- Numero de Error en transaccion
    DECLARE Var_MntComisi		DECIMAL(12,2);		-- Monto de Comision
    DECLARE Var_MntIVAComisi	DECIMAL(12,2);		-- IVA de Comision
    -- << -- Variables

    DECLARE Es_Local            CHAR(1);			-- Es local
    DECLARE Es_Internacional    CHAR(1);			-- Es internacional
    DECLARE Entero_Cero         INT(1);				-- Entero cero
    DECLARE Entero_uno			INT(1);				-- Entero uno
	DECLARE Origen_Archivo      CHAR(1);			-- Oriegen archivo
    DECLARE Salida_SI           CHAR(1);			-- SALIDA SI
    DECLARE Trans_POS           VARCHAR(5);			-- Transacc POS
    DECLARE Des_TransLocal      VARCHAR(50);		-- Des transaccion local
    DECLARE Entero_Vacio        VARCHAR(5);			-- Entero cero
    DECLARE Cadena_Vacia        VARCHAR(5);			-- cadena vacia
    DECLARE TipoArchivoEmi		VARCHAR(50);		-- Tipo archivo para filtro de tipo de operacion
    DECLARE EstatusActivo		CHAR(1);			-- Estatus activo
    DECLARE Tipo_EMI			CHAR(1);			-- Tipo E
    DECLARE Tipo_STATS			CHAR(1);			-- Tipo S
    DECLARE Tipo_TransRechazada	CHAR(1);			-- Transaccion rechazada 9
    DECLARE CR_Correct1			VARCHAR(3);			-- Codigo Transaccion correcta STATS 1
    DECLARE CR_Correct2			VARCHAR(3);			-- Codigo Transaccion correcta STATS 1
    DECLARE CodAprobVacio 		VARCHAR(6);			-- Codigo de Aprobacion vacio para STATS
    DECLARE NaturalezaCompra	CHAR(1);			-- Naturaleza de compra
	DECLARE NaturalezaPago		CHAR(1);			-- Naturaleza de pago
	DECLARE Var_MonedaMex		CHAR(5);            -- Codigo Moneda Mex
	DECLARE Cadena_Cero			CHAR(1);			-- Cadena Cero
	DECLARE Origen_Stats		CHAR(1);
	DECLARE Origen_Emi			CHAR(1);
	
	DECLARE Var_Dia				VARCHAR(5);
	DECLARE Var_Mes				VARCHAR(5);
	DECLARE Var_Anio			VARCHAR(5);
	
	DECLARE FechaOperaNueva		DATE;
	
    SET Cadena_Vacia            := '';		-- Cadena vacia
    SET Var_SalidaNo            := 'N';		-- Slida no
    SET Es_Local                := 'L';		-- Es local
    SET Es_Internacional        := 'I';		-- Es internacional
    SET Entero_Cero             := 0;		-- Entero cero
    SET Entero_uno				:= 1;		-- Entero uno
    SET Origen_Archivo          := 'A';		-- Origen archivo
    SET Trans_POS               := '1200';	-- Transaccion POS
    SET Entero_Vacio            := '0.00';	-- Entero vacio
    SET Salida_SI               := 'S';		-- Salida si
    SET Des_TransLocal          := 'Incoming Local';	-- Des trans local

    SET Tipo_EMI				:= 'E';    	-- Tipo  E
    SET Tipo_STATS				:= 'S';    	-- Tipo S
    SET Tipo_TransRechazada		:= '9';   	-- EMI Transaccion Rechazada
	SET CR_Correct1				:= '000';  	-- Codigo Transaccion correcta STATS 1
	SET CR_Correct2				:= '001';  	-- Codigo Transaccion correcta STATS 2
	SET TipoArchivoEmi			:= '510';	-- Tipo archivo para filtro de tipo de operacion
	SET EstatusActivo			:= 'A';		-- Estatus activo
	SET NaturalezaCompra		:= 'C';		-- Naturaleza de compra
	SET NaturalezaPago			:= 'D';		-- Naturaleza de pago
	SET CodAprobVacio			:= '000000';-- Codigo de Aprobacion vacio

	SET Var_DatosTiempoAire     := '';			-- Datos tiempo aire
	SET Var_PosFila             := 1;			-- Posicion fila
    SET Var_CountProcesados     := 0;			-- Contador procesados
    SET Var_HoraOperacion       := '12:00:00';	-- Hora operacion
	SET Var_Exitosos            := 0;			-- Contador exitosos compras
	SET Var_ExitososPago        := 0;			-- COntador exitosos pagos
	SET Var_FallidosPago        := 0;			-- Contador fallidos pagos
    SET Var_Fallidos            := 0;			-- Contador fallidos compraas
	SET Var_OrigenPago			:= 'T';			-- Origen de pago
    SET Var_EstatusRegistrado	:= 'R';			-- Asignacion estatus Registrado
	SET Var_EstatusProcesado	:= 'P';			-- Asinacion estatus Procesado
	SET Var_EstatusCancelado	:= 'C';			-- Asignacion estatus cancelado
    SET Var_MaxFilas			:= 0;			-- Maximo filas
    SET Var_TipoTransaccion		:= '';			-- Tipo Transaccion
    SET Var_MonedaMex       	:= '484';		-- Codigo Moneda Mex
    SET Cadena_Cero				:= '0';			-- Cadena Cero
	
	SET Origen_Stats			:='T';
	SET Origen_Emi				:='E';
	
	

ManejoErrores:BEGIN

    DECLARE EXIT HANDLER FOR SQLEXCEPTION
      BEGIN
        SET Par_NumErr  = 999;
        SET Par_ErrMen  = CONCAT('El SAFI ha tenido un problema al concretar la operacion. Disculpe las molestias que ',
                  'esto le ocasiona. Ref: SP-TC_ARCHIVOMOVSPRO');
      END;

    -- Verificamos que el archivo no fuese procesado previamente
	SELECT COUNT(*)
		INTO Var_MaxFilas
		FROM TC_ARCHIVOMOVS
		WHERE NumTranCarga = Par_NumTranCarga
		AND Estatus <> Var_EstatusRegistrado;

    SET Var_MaxFilas := IFNULL(Var_MaxFilas,Entero_Cero);

    IF (Var_MaxFilas > Entero_Cero) THEN
        SET Par_NumErr:= 100;
        SET Par_ErrMen:= 'El archivo fue procesado previamente.';
        LEAVE ManejoErrores;
    END IF;

	-- Comprobar el contenido del archivo
	SET Var_MaxFilas := Entero_Cero;
	SELECT COUNT(*)
	INTO Var_MaxFilas
	FROM TC_ARCHIVOMOVS
	WHERE NumTranCarga = Par_NumTranCarga
	AND Estatus = Var_EstatusRegistrado;

    SET Var_MaxFilas := IFNULL(Var_MaxFilas,Entero_Cero);

    IF (Var_MaxFilas = Entero_Cero) THEN
        SET Par_NumErr:= 101;
        SET Par_ErrMen:= 'Archivo Vacio';
        LEAVE ManejoErrores;
    END IF;

	-- Se obtiene el texto del la linea del archivo gurdado
    SELECT 	TipoArchivo
    INTO Var_TipoArchivo
    FROM TC_ARCHIVOMOVS 
	WHERE NumTranCarga = Par_NumTranCarga
	AND Estatus = Var_EstatusRegistrado
	AND NumLinea = 1;
	
	SET Var_TipoArchivo		:= IFNULL(Var_TipoArchivo, Cadena_Vacia);
	
	IF(Var_TipoArchivo = Cadena_Vacia) THEN
        SET Par_NumErr:= 102;
        SET Par_ErrMen:= 'No existe el tipo de archivo.';
        LEAVE ManejoErrores;
    END IF;
	
	SELECT FechaSistema
        INTO Var_FechaSistema
        FROM PARAMETROSSIS
        WHERE EmpresaID = Aud_EmpresaID;
	
	
	IF(Var_TipoArchivo = Tipo_EMI) THEN
		-- ----------------------------------------------------------
		--  Se revisan los encabezados del archivo
		-- ----------------------------------------------------------
		SELECT Registro
			INTO Var_TxtFila
			FROM TC_ARCHIVOMOVS
			WHERE NumTranCarga = Par_NumTranCarga
			AND NumLinea = 1 
			AND TipoArchivo = Var_TipoArchivo;
		
		-- ----------------------------------------------------------
		--  Se inicia el ciclo para procesar cada linea del archivo
		--  Inicia a partir de la linea 1
		-- ----------------------------------------------------------
		SET Var_PosFila := 1;
		SET Var_TxtTotalAplicar := Entero_Cero;
		
		WHILE Var_PosFila <= Var_MaxFilas do
			CicloWhile:BEGIN
				SET Var_Registro := NULL;
				SET Var_CT := NULL;
				SET Var_Tarjeta := NULL;
				SET Var_NombreNegocio := NULL;
				SET Var_Ciudad := NULL;
				SET Var_Pais := NULL;
				SET Var_MCC := NULL;
				SET Var_Valor := NULL;
				SET Var_Moneda := NULL;
				SET var_Referencia := NULL;
				SET var_FTran := NULL;
				SET Var_CPD := NULL;
				SET Var_IRD := NULL;
				SET Var_Autorizacion := NULL;
				SET Var_IVA := NULL;
				SET Var_FechaOperacion := NULL;
				SET Var_DescOperacion := NULL;
				SET Var_CantOperaciones := NULL;
				
				SELECT Registro, Tc_ArchivoMovsID
					INTO Var_TxtFila, Var_Tc_ArchivoMovsID
					FROM TC_ARCHIVOMOVS
					WHERE NumTranCarga = Par_NumTranCarga
					AND NumLinea = Var_PosFila;
				
				-- Si la naturaleza no se encuentra continuamos con el siguente registro
				SET Var_Naturaleza := TRIM(SUBSTR(Var_TxtFila, 25, 1));
				IF(Var_Naturaleza = Cadena_Vacia) THEN
					SET Var_Fallidos    := Var_Fallidos + 1;
					UPDATE TC_ARCHIVOMOVS SET
					Estatus 		= Var_EstatusCancelado,
					MotivoCancel 	= 'No se pudo determinar la naturaleza del movimiento'
					WHERE  NumTranCarga = Par_NumTranCarga
					AND NumLinea = Var_PosFila;
					
					LEAVE CicloWhile;
				END IF;
				IF(SUBSTR(Var_TxtFila, 41,6) = '000000' OR SUBSTR(Var_TxtFila, 41,6) = Cadena_Vacia  ) THEN
					SET Var_Fallidos    := Var_Fallidos + 1;
					
					UPDATE TC_ARCHIVOMOVS SET
					Estatus 		= Var_EstatusCancelado,
					MotivoCancel 	= 'Fecha incorrecta'
					WHERE  NumTranCarga = Par_NumTranCarga
					AND NumLinea = Var_PosFila;
					
					LEAVE CicloWhile;
				END IF;
				
				-- SE HACE EL MOVIMIENTO DEPENDIENDO DE LA NATURALEZA
				-- C compras
				-- D Pagos
				SELECT 	
					TRIM(substr(Var_TxtFila ,47,2))    AS CT ,
					TRIM(substr(Var_TxtFila ,06,19))  AS Tarjeta,
					TRIM(substr(Var_TxtFila ,263,30))  AS NombreNegocio ,
					TRIM(substr(Var_TxtFila ,346,13))  AS Ciudad ,
					TRIM(substr(Var_TxtFila ,333,3))   AS Pais ,
					TRIM(substr(Var_TxtFila ,258,5))   AS MCC ,
					TRIM(substr(Var_TxtFila ,80,13))  AS Valor ,
					TRIM(substr(Var_TxtFila ,77,3))   AS Moneda ,
					TRIM(substr(Var_TxtFila ,397,23))  AS Referencia ,
					TRIM(substr(Var_TxtFila ,29,6))  AS FTran ,
					TRIM(substr(Var_TxtFila ,132,6))  AS CPD ,
					TRIM(substr(Var_TxtFila ,364,2))  AS IRD ,
					TRIM(substr(Var_TxtFila ,386,6)) AS Autorizacion ,
					TRIM(substr(Var_TxtFila ,437,7)) AS IVA,
					TRIM(SUBSTR(Var_TxtFila, 41,6)) AS FechaProceso
					-- TRIM(substr(Var_TxtFila ,146,16)) AS Comision ,
					INTO  	Var_DescOperacion,		Var_Tarjeta,		Var_NombreNegocio,		Var_Ciudad,    		Var_Pais,
							Var_MCC,				Var_Valor,     		Var_Moneda,       		Var_Referencia,		Var_FTran,
							Var_CPD,          		Var_IRD,			Var_Autorizacion, 		Var_IVA,			Var_FechaOperacion;

				-- Valida si se tiene un codigo de aprobacion diferente de vacio
				IF (Var_Autorizacion = CodAprobVacio) THEN
	                SET Var_Fallidos    := Var_Fallidos + 1;
	                
					UPDATE TC_ARCHIVOMOVS SET
						Estatus 		= Var_EstatusCancelado,
						MotivoCancel 	= 'Codigo de Aprobacion no valido'
						WHERE  NumTranCarga = Par_NumTranCarga
					AND NumLinea = Var_PosFila;
					LEAVE CicloWhile;
				END IF;

                SELECT COUNT(DISTINCT(TipoOperacionID))
					INTO Var_CantOperaciones
					FROM CATTRANSACCIONESPROSA
					WHERE Tipo = Var_DescOperacion
					AND TipoCatalogo = Tipo_EMI;
					
				IF(Var_CantOperaciones > 1) THEN
					UPDATE TC_ARCHIVOMOVS SET
					Estatus 		= Var_EstatusCancelado,
					MotivoCancel 	= 'Se encontraron dos tipos de operaciones parametrizadas en el catalogo para la descripcion'
					WHERE  NumTranCarga = Par_NumTranCarga
				AND NumLinea = Var_PosFila;
				END IF;
					
				SELECT CAT.TipoOperacionID 
						INTO Var_CT
					FROM CATTRANSACCIONESPROSA CAT
					INNER JOIN TC_TIPOSOPERACION TCO ON TCO.TipoOperacionID = CAT.TipoOperacionID 
					WHERE CAT.Tipo = Var_DescOperacion AND TipoCatalogo = Tipo_EMI;
					
				SET Var_CT := IFNULL(Var_CT, Cadena_Vacia);
				-- Si el registro tiene un tipo de movimiento valido obtenemos los demas valores
				IF(Var_CT = Cadena_Vacia) THEN
					SET Var_Fallidos    := Var_Fallidos + 1;
					UPDATE TC_ARCHIVOMOVS SET
						Estatus 		= Var_EstatusCancelado,
						MotivoCancel 	= CONCAT('Tipo de Operacion no encontrada (', Var_CT, ')')
						WHERE  NumTranCarga = Par_NumTranCarga
						AND NumLinea = Var_PosFila;
					
					-- Continuamos con la siguiente linea.
					LEAVE CicloWhile;
				END IF;
				
				-- Se eliminan las comas del monto de transaccion
				SET Var_IVA := REPLACE(Var_IVA,',','.');
				SET Var_FechaOperacionPago	:= DATE_FORMAT(Var_FechaOperacion, '%d/%m/%Y');
				SET Var_Valor := REPLACE(Var_Valor,',','');
				
				-- SE HACE EL MOVIMIENTO DEPENDIENDO DE LA NATURALEZA
				-- C compras
				-- D Pagos
				IF(Var_Naturaleza = NaturalezaCompra) THEN
					-- LLAMAR TC_TRANSACCIONESPRO
					START TRANSACTION;
					TransaccionCompraEMI:BEGIN
						DECLARE EXIT HANDLER FOR SQLEXCEPTION SET Error_Key = 1;
						DECLARE EXIT HANDLER FOR SQLSTATE '23000' SET Error_Key = 2;
						DECLARE EXIT HANDLER FOR SQLSTATE '42000' SET Error_Key = 3;
						DECLARE EXIT HANDLER FOR SQLSTATE '22004' SET Error_Key = 4;

						SET Error_Key := Entero_Cero;
						SET Par_NumErr := Entero_Cero;

						CALL TC_TRANSACCIONESPRO(
							Origen_Emi,			Trans_POS,      Var_CT,              Var_Tarjeta,           Var_Valor,
							Entero_Cero,        Entero_Cero,    Entero_Cero,         Var_Moneda,            Var_FechaOperacion,
							Var_HoraOperacion,  Var_MCC,        Cadena_Vacia,        Var_NombreNegocio,     Var_Ciudad,
							Var_Pais,           Var_Referencia, Var_DatosTiempoAire, Var_Autorizacion,      Cadena_Vacia,
							Var_SalidaNo,       Par_NumErr,     Par_ErrMen ,

							Aud_EmpresaID,      Aud_Usuario,    Aud_FechaActual,     Aud_DireccionIP,       Aud_ProgramaID,
							Aud_Sucursal,       Aud_NumTransaccion);
					END TransaccionCompraEMI;
					IF Error_Key = 0 AND  Par_NumErr = 0 THEN
						COMMIT;
					ELSE
						SET Par_NumErr := IF(Error_Key = 0, Par_NumErr, Error_Key);
						ROLLBACK;
					END IF;

					-- Se hace la llamada el SP para procesar las operaciones
					IF Par_NumErr = Entero_Cero THEN
						SET Var_Exitosos    := Var_Exitosos + 1;
						
						UPDATE TC_ARCHIVOMOVS SET
							Estatus 		= Var_EstatusProcesado
							WHERE  NumTranCarga = Par_NumTranCarga
							AND NumLinea = Var_PosFila;
					ELSE
						SET Var_Fallidos    := Var_Fallidos + 1;
						
						UPDATE TC_ARCHIVOMOVS SET
							Estatus 		= Var_EstatusCancelado,
							MotivoCancel 	= CONCAT('Error al registrar el movimiento(C): ', Par_ErrMen)
							WHERE  NumTranCarga = Par_NumTranCarga
							AND NumLinea = Var_PosFila;
						
					END IF;
				END IF;
				
				IF(Var_Naturaleza = NaturalezaPago) THEN
					-- LLAMAR TC_PAGOLINEAPRO
					-- CuentaClabe
					SELECT 	CuentaClabe
						INTO 	Var_CuentaClave 
						FROM  TARJETACREDITO WHERE TarjetaCredID = Var_Tarjeta;
					
					IF (IFNULL(Var_CuentaClave, Entero_Cero) = Entero_Cero) THEN
						UPDATE TC_ARCHIVOMOVS SET
							Estatus 		= Var_EstatusCancelado,
							MotivoCancel 	= 'No se encontro la cuenta clabe'
							WHERE  NumTranCarga = Par_NumTranCarga
							AND NumLinea = Var_PosFila;
							
						SET Var_FallidosPago	:= Var_FallidosPago + 1;
					END IF;
					IF IFNULL(Var_CuentaClave, Entero_Cero) != Entero_Cero THEN
						START TRANSACTION;
						TransaccionPagoEMI:BEGIN
							DECLARE EXIT HANDLER FOR SQLEXCEPTION SET Error_Key = 1;
							DECLARE EXIT HANDLER FOR SQLSTATE '23000' SET Error_Key = 2;
							DECLARE EXIT HANDLER FOR SQLSTATE '42000' SET Error_Key = 3;
							DECLARE EXIT HANDLER FOR SQLSTATE '22004' SET Error_Key = 4;

							SET Error_Key := Entero_Cero;
							SET Par_NumErr := Entero_Cero;

							CALL TC_PAGOLINEAPRO(
											Var_Tarjeta, 			Var_CuentaClave, 			Var_Referencia,		Var_Valor, 			Var_Moneda,
											Par_NumTranCarga, 		Var_FechaOperacionPago, 	Var_NumeroTransacc, Var_SaldoContable,	Var_SaldoDispoAct,	
											Var_CodigoResp,			Var_FechaAplicacion,		Var_TarCredMovID, 	Var_OrigenPago,		Par_Salida,			
											Par_NumErr,				Par_ErrMen,					Aud_EmpresaID,		Aud_Usuario,		Aud_FechaActual,	Aud_DireccionIP,	
											Aud_ProgramaID,			Aud_Sucursal, Aud_NumTransaccion);

						END TransaccionPagoEMI;
						IF Error_Key = 0 AND  Par_NumErr = 0 THEN
							COMMIT;
						ELSE
							SET Par_NumErr := IF(Error_Key = 0, Par_NumErr, Error_Key);
							ROLLBACK;
						END IF;
										
						IF Par_NumErr = Entero_Cero THEN
							SET Var_ExitososPago    := Var_ExitososPago + 1;
							UPDATE TC_ARCHIVOMOVS SET
								Estatus 		= Var_EstatusProcesado
								WHERE  NumTranCarga = Par_NumTranCarga
								AND NumLinea = Var_PosFila;
						ELSE
							SET Var_FallidosPago	:= Var_FallidosPago + 1;
							UPDATE TC_ARCHIVOMOVS SET
								Estatus 		= Var_EstatusCancelado,
								MotivoCancel 	= Par_ErrMen
								WHERE  NumTranCarga = Par_NumTranCarga
								AND NumLinea = Var_PosFila;
						END IF;
					END IF;
				END IF;

				SET Var_TxtTotalAplicar := Var_TxtTotalAplicar + CAST(Var_Valor AS DECIMAL(10,2));
				SET Var_CountProcesados := Var_CountProcesados + 1;
			END CicloWhile;
			SET Var_PosFila := Var_PosFila + 1;
		END WHILE;
	END IF;
	
	 
	IF(Var_TipoArchivo = Tipo_STATS) THEN
		-- ----------------------------------------------------------
		SET Var_Fallidos      := 0;
		SELECT Registro
			INTO Var_TxtFila
			FROM TC_ARCHIVOMOVS
			WHERE NumTranCarga = Par_NumTranCarga
			AND NumLinea = 1 
			AND TipoArchivo = Var_TipoArchivo;
		
		-- ----------------------------------------------------------
		--  Se inicia el ciclo para procesar cada linea del archivo
		--  Inicia a partir de la linea 1
		-- ----------------------------------------------------------
		SET Var_PosFila := 1;
		SET Var_TxtTotalAplicar := Entero_Cero;
		
		
		WHILE Var_PosFila <= Var_MaxFilas do
			CicloWhileStats:BEGIN
			
			SET Var_CT := NULL;
			SET Var_Tarjeta := NULL;
			SET Var_NombreNegocio := NULL;
			SET Var_Ciudad := NULL;
			SET Var_Pais := NULL;
			SET Var_MCC := NULL;
			SET Var_Valor := NULL;
			SET Var_Moneda := NULL;
			SET Var_Referencia := NULL;
			SET Var_FTran := NULL;
			SET Var_CPD := NULL;
			SET Var_IRD := NULL;
			SET Var_Autorizacion := NULL;
			SET Var_IVA := NULL;
			SET Var_FechaOperacion := NULL;
			SET Var_Registro := NULL;
			SET Var_DescOperacion := NULL;
			SET Var_CantOperaciones := NULL;
			SET FechaOperaNueva := NULL;
			SET Var_Cajero := NULL;
			
			SELECT Registro, Tc_ArchivoMovsID
			INTO Var_TxtFila, Var_Tc_ArchivoMovsID
			FROM TC_ARCHIVOMOVS
			WHERE NumTranCarga = Par_NumTranCarga
			AND NumLinea = Var_PosFila;
			
			SET Var_TipoTransaccion := SUBSTR(Var_TxtFila,115,3);
			SET Var_DescOperacion := SUBSTR(Var_TxtFila,91,8);

			-- Valida si se tiene un codigo de aprobacion diferente de vacio
			IF (Var_TipoTransaccion = CodAprobVacio) THEN
                SET Var_Fallidos    := Var_Fallidos + 1;
                
				UPDATE TC_ARCHIVOMOVS SET
					Estatus 		= Var_EstatusCancelado,
					MotivoCancel 	= 'Codigo de Aprobacion no valido'
					WHERE  NumTranCarga = Par_NumTranCarga
				AND NumLinea = Var_PosFila;
				LEAVE CicloWhileStats;
			END IF;
			
			
			-- EN CASO DE QUE GENERE MOVIMIENTO
			-- Validar la existencia de un tipo de operacion
			SELECT COUNT(DISTINCT(TipoOperacionID))
				INTO Var_CantOperaciones
				FROM CATTRANSACCIONESPROSA
				WHERE Valor = Var_DescOperacion
				AND TipoCatalogo = Tipo_STATS;
				
			IF(Var_CantOperaciones > 1) THEN
                SET Var_Fallidos    := Var_Fallidos + 1;
                
				UPDATE TC_ARCHIVOMOVS SET
				Estatus 		= Var_EstatusCancelado,
				MotivoCancel 	= 'Se encontraron dos tipos de operaciones parametrizadas en el catalogo para la descripcion'
				WHERE  NumTranCarga = Par_NumTranCarga
                AND NumLinea = Var_PosFila;
                
                LEAVE CicloWhileStats;
			END IF;
			
			SELECT CAT.TipoOperacionID 
					INTO Var_CT
				FROM CATTRANSACCIONESPROSA CAT
				INNER JOIN TC_TIPOSOPERACION TCO ON TCO.TipoOperacionID = CAT.TipoOperacionID 
				WHERE CAT.Valor = Var_DescOperacion AND TipoCatalogo = Tipo_STATS;
			
			SET Var_CT := IFNULL(Var_CT, Cadena_Vacia);
			
			-- Si el registro tiene un tipo de movimiento valido obtenemos los demas valores
			IF(Var_CT = Cadena_Vacia) THEN
				SET Var_Fallidos    := Var_Fallidos + 1;
				
				UPDATE TC_ARCHIVOMOVS SET
					Estatus 		= Var_EstatusCancelado,
					MotivoCancel 	= CONCAT('Tipo de Operacion no encontrada (', Var_CT, ')')
					WHERE  NumTranCarga = Par_NumTranCarga
					AND NumLinea = Var_PosFila;
				
				-- Continuamos con la siguiente linea.
				LEAVE CicloWhileStats;
			END IF;

			-- SE HACE EL MOVIMIENTO DEPENDIENDO DE LA NATURALEZA
			-- C compras
			SELECT 	
					TRIM(substr(Var_TxtFila ,25,19))  AS Tarjeta,
					-- TRIM(substr(Var_TxtFila ,262,10))  AS NombreNegocio ,
					TRIM(substr(Var_TxtFila ,262,1))  AS Ciudad ,			-- No se encontró en el layout
					TRIM(substr(Var_TxtFila ,209,2))   AS Pais ,
					TRIM(substr(Var_TxtFila ,258,5))   AS MCC , 			-- No se encontro en el layout comercio giro
					TRIM(substr(Var_TxtFila ,181,10))  AS Valor ,
					TRIM(substr(Var_TxtFila ,228,3))   AS Moneda , 			-- No se encontro en el layout
					TRIM(substr(Var_TxtFila ,121,3))  AS Referencia ,		-- No se encontro en el layout
					TRIM(substr(Var_TxtFila ,150,8))  AS FTran ,
					TRIM(substr(Var_TxtFila ,132,6))  AS CPD ,
					TRIM(substr(Var_TxtFila ,364,2))  AS IRD ,				-- No se encontro en el layout
					TRIM(substr(Var_TxtFila ,201,6)) AS Autorizacion ,
					TRIM(substr(Var_TxtFila ,202,7)) AS IVA,				-- No se encontro en el layout
					TRIM(SUBSTR(Var_TxtFila, 150,8)) AS FechaProceso,		-- Será la del sistema
					TRIM(SUBSTR(Var_TxtFila, 136,10)) AS Cajero,			-- Será la del sistema
					TRIM(SUBSTR(Var_TxtFila, 233,10)) AS MontoComision		-- Monto de Comision
				INTO Var_Tarjeta,      		Var_Ciudad,    			Var_Pais,				Var_MCC,				Var_Valor,
					 Var_Moneda,       		Var_Referencia,			Var_FTran,				Var_CPD,				Var_IRD,
					 Var_Autorizacion, 		Var_IVA,				Var_FechaOperacion, 	Var_Cajero,				Var_Comision;

			SET Var_Valor := REPLACE(Var_Valor,',','');
			SET Var_Valor := CAST(Var_Valor AS DECIMAL(16,2)) - CAST(Var_Comision AS DECIMAL(16,2));

			-- Calculamos la comision y su IVA
			SET Var_Comision := IFNULL(Var_Comision, Cadena_Cero);
			SET Var_MntComisi := CONVERT(Var_Comision, DECIMAL(12,2));
			IF(Var_MntComisi <= Entero_Cero) THEN
				SET Var_MntComisi := Entero_Cero;
				SET Var_MntIVAComisi := Entero_Cero;
			ELSE
				SET Var_MntIVAComisi := ROUND(ROUND(Var_MntComisi / 1.16,2) * 0.16, 2);
				SET Var_MntComisi := Var_MntComisi - Var_MntIVAComisi;
			END IF;
			
				
			-- Se eliminan las comas del monto de transaccion
			-- SET Var_IVA := REPLACE(Var_IVA,',','.');
			-- SET Var_FechaOperacion	:= DATE_FORMAT(Var_FechaOperacion, '%m/%d/%Y');
			-- 12/07/20
			
			SET Var_Dia := SUBSTR(Var_FechaOperacion,1,2);
			SET Var_Mes := SUBSTR(Var_FechaOperacion,4,2);
			SET Var_Anio := SUBSTR(Var_FechaOperacion,7,2);
			
			SET FechaOperaNueva := CONCAT(Var_Anio,'/',Var_Mes,'/',Var_Dia);
			
			SET Var_Naturaleza := NaturalezaCompra;
			-- Para el archivo STATS se define el nombre del comercion el nombre de la terminal o cajero.
			-- SET Var_NombreNegocio := IF(Var_Cajero IS NULL OR Var_Cajero = Cadena_Vacia, 'Retiro Cajero Automatico', Var_Cajero);

			-- SE HACE EL MOVIMIENTO DEPENDIENDO DE LA NATURALEZA
			-- C compras
			IF(Var_Naturaleza = NaturalezaCompra) THEN
				-- LLAMAR TC_TRANSACCIONESPRO
				START TRANSACTION;
				TransaccionCompraSTATS:BEGIN
					DECLARE EXIT HANDLER FOR SQLEXCEPTION SET Error_Key = 1;
					DECLARE EXIT HANDLER FOR SQLSTATE '23000' SET Error_Key = 2;
					DECLARE EXIT HANDLER FOR SQLSTATE '42000' SET Error_Key = 3;
					DECLARE EXIT HANDLER FOR SQLSTATE '22004' SET Error_Key = 4;

					SET Error_Key := Entero_Cero;
					SET Par_NumErr := Entero_Cero;

					CALL TC_TRANSACCIONESPRO(
						Origen_Stats,	    Trans_POS,      Var_CT,					Var_Tarjeta,           Var_Valor,
						Entero_Cero,        Var_MntComisi,  Var_MntIVAComisi,		Var_MonedaMex,         FechaOperaNueva,
						Var_HoraOperacion,  Var_MCC,        Cadena_Vacia,        	Var_Cajero,			   Cadena_Vacia,
						Var_Pais,           Var_Referencia, Var_DatosTiempoAire, 	Var_Autorizacion,      Cadena_Vacia,
						Var_SalidaNo,       Par_NumErr,     Par_ErrMen ,

						Aud_EmpresaID,      Aud_Usuario,    Aud_FechaActual,     Aud_DireccionIP,       Aud_ProgramaID,
						Aud_Sucursal,       Aud_NumTransaccion);
				END TransaccionCompraSTATS;
				IF Error_Key = 0 AND Par_NumErr = 0 THEN
					COMMIT;
				ELSE	
					SET Par_NumErr := IF(Error_Key = 0, Par_NumErr, Error_Key);
					ROLLBACK;
				END IF;
				
				-- Se valida las respuestas de las operaciones
				IF Par_NumErr = Entero_Cero THEN
					SET Var_Exitosos    := Var_Exitosos + 1;
					
					UPDATE TC_ARCHIVOMOVS SET
						Estatus 		= Var_EstatusProcesado
						WHERE  NumTranCarga = Par_NumTranCarga
						AND NumLinea = Var_PosFila;
				ELSE
					SET Var_Fallidos    := Var_Fallidos + 1;
					
					UPDATE TC_ARCHIVOMOVS SET
						Estatus 		= Var_EstatusCancelado,
						MotivoCancel 	= CONCAT('Error al registrar el movimiento(C): ', Par_ErrMen)
						WHERE  NumTranCarga = Par_NumTranCarga
						AND NumLinea = Var_PosFila;
				END IF;
			END IF;
			SET Var_TxtTotalAplicar := Var_TxtTotalAplicar + CAST(Var_Valor AS DECIMAL(10,2));
			SET Var_CountProcesados := Var_CountProcesados + 1;

			END CicloWhileStats;	
			SET Var_PosFila := Var_PosFila + 1;
		END WHILE;
	END IF;

	IF(Var_TipoArchivo = TipoArchivoEmi) THEN
		SET Par_NumErr:= 0;
		SET Par_ErrMen:= CONCAT('Compras Exitosas: ', Var_Exitosos, ' Pagos Exitosos: ', Var_ExitososPago, ' Fallidas Compras: ', Var_Fallidos, ' Fallidas Pagos: ', Var_FallidosPago );
	ELSE
		SET Par_NumErr:= 0;
		SET Par_ErrMen:= CONCAT('Compras Exitosas: ', Var_Exitosos, ' Fallidas Compras: ', Var_Fallidos);
	END IF;


END ManejoErrores;

    IF Par_Salida = Salida_SI THEN
        SELECT Par_NumErr AS NumErr,
               Par_ErrMen AS ErrMen,
               Var_Exitosos AS NumExitosos,
               Var_Fallidos AS NumFallidos,
               Var_CountProcesados AS NumProcesados;

    END IF;
END TerminaStore$$
