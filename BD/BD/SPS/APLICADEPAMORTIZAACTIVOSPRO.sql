-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- APLICADEPAMORTIZAACTIVOSPRO
DELIMITER ;
DROP PROCEDURE IF EXISTS `APLICADEPAMORTIZAACTIVOSPRO`;DELIMITER $$

CREATE PROCEDURE `APLICADEPAMORTIZAACTIVOSPRO`(
# =====================================================================================
# -------------- APLICACION DE DEPRECIACION Y AMORTIZACION DE ACTIVOS -----------------
# =====================================================================================
	Par_Anio			INT(11),			-- Anio
	Par_Mes				INT(11),			-- Mes
    Par_UsuarioID		INT(11), 			-- Usuario que realilza el proceso de depreciacion y amortizacion
	Par_SucursalID		INT(11), 			-- Sucursal donde se realiza el proceso de depreciacion y amortizacion
    Par_PolizaID 		BIGINT(20),  		-- Numero de poliza

    Par_Salida 			CHAR(1),			-- Indica si espera un SELECT de Salida
	INOUT Par_NumErr 	INT(11),			-- Numero de Error
	INOUT Par_ErrMen 	VARCHAR(400),		-- Descripcion de Error

	Par_EmpresaID       INT(11),			-- Parametro de Auditoria
    Aud_Usuario         INT(11),			-- Parametro de Auditoria
    Aud_FechaActual     DATETIME,			-- Parametro de Auditoria
    Aud_DireccionIP     VARCHAR(15),		-- Parametro de Auditoria
    Aud_ProgramaID      VARCHAR(50),		-- Parametro de Auditoria
    Aud_Sucursal        INT(11),			-- Parametro de Auditoria
    Aud_NumTransaccion  BIGINT(20)			-- Parametro de Auditoria
	)
TerminaStore: BEGIN

	-- Declaracion de Variables
    DECLARE Var_Consecutivo		VARCHAR(100);   	-- Variable consecutivo
	DECLARE Var_Control 		VARCHAR(100);
	DECLARE Var_FechaInicio 	DATE;
	DECLARE Var_FechaFin 		DATE;
    DECLARE Var_FechaSistema	DATE;
    DECLARE Var_Poliza			BIGINT(20);

    DECLARE Var_AltaEncPol		CHAR(1);
    DECLARE Var_Clave			VARCHAR(45);
    DECLARE Var_Fecha			DATE;
    DECLARE Var_Hora 			TIME;

    -- DECLARACION DE VARIABLES CURSOR
    DECLARE Var_DepreAmortiID	INT(11);
    DECLARE Var_ActivoID		INT(11);
    DECLARE Var_TipoActivoID	INT(11);
    DECLARE Var_MontoDepreciar	DECIMAL(16,2);
    DECLARE Var_ClasificaActivoID	INT(11);
	DECLARE Error_Key           INT DEFAULT 0;      -- variable para manejo de errores
    DECLARE Var_DepreAcumuIni	DECIMAL(16,2);
 	DECLARE Var_TotalDepreIni	DECIMAL(16,2);

	-- Declaracion de Constantes
	DECLARE Cadena_Vacia		CHAR(1);
	DECLARE Fecha_Vacia			DATE;
	DECLARE Entero_Cero			INT(11);
	DECLARE Decimal_Cero		INT(11);
    DECLARE Salida_SI 			CHAR(1);

	DECLARE Salida_NO 			CHAR(1);
    DECLARE Cons_SI 			CHAR(1);
	DECLARE Cons_NO 			CHAR(1);
    DECLARE Est_Registrado		CHAR(1);
	DECLARE Deprecia_Mensual	INT(11);		-- 	'1', 'DEPRECIACION MENSUAL', (CONCEPTOSACTIVOS)

	DECLARE Amortiza_Mensual	INT(11);		-- 	'2', 'AMORTIZACION MENSUAL', (CONCEPTOSACTIVOS)
	DECLARE Deprecia_Acumula	INT(11);		-- 	'3', 'DEPRECIACION ACUMULADA', (CONCEPTOSACTIVOS)
	DECLARE Amortiza_Acumula	INT(11);		-- 	'4', 'AMORTIZACION ACUMULADA', (CONCEPTOSACTIVOS)
    DECLARE MonedaID			INT(11);
	DECLARE	Nat_Cargo			CHAR(1);

    DECLARE	Nat_Abono			CHAR(1);
    DECLARE Est_Aplicado		CHAR(1);
    DECLARE Est_Vigente			CHAR(2);
    DECLARE Est_Baja			CHAR(2);

    -- DECLARACION DE CURSORES
     DECLARE CURSORACTIVOSDEPREAMOR CURSOR FOR
		SELECT 	BDA.DepreAmortiID, 			BDA.ActivoID, 		ACT.TipoActivoID,	BDA.MontoDepreciar,		TIP.ClasificaActivoID,
				ACT.DepreciadoAcumulado, 	ACT.TotalDepreciar
		FROM ACTIVOS ACT
			INNER JOIN BITACORADEPREAMORTI BDA
				ON ACT.ActivoID = BDA.ActivoID
			INNER JOIN TIPOSACTIVOS TIP
				ON ACT.TipoActivoID = TIP.TipoActivoID
		WHERE BDA.Estatus = Est_Registrado
			AND BDA.Anio = Par_Anio
			AND BDA.Mes = Par_Mes
            AND ACT.Estatus IN(Est_Vigente,Est_Baja);

	-- Asignacion de Constantes
	SET Cadena_Vacia		:= '';    			-- Cadena Vacia
	SET Fecha_Vacia			:= '1900-01-01';	-- Fecha Vacia
	SET Entero_Cero			:= 0;				-- Entero Cero
	SET Decimal_Cero		:= 0.0;				-- DECIMAL Cero
	SET Salida_SI 			:= 'S'; 			-- Salida: SI

	SET Salida_NO 			:= 'N'; 			-- Salida: NO
    SET Cons_SI 			:= 'S';
	SET Cons_NO 			:= 'N';
    SET Est_Registrado		:= 'R';
    SET Deprecia_Mensual 	:= 1;

    SET Amortiza_Mensual 	:= 2;
    SET Deprecia_Acumula 	:= 3;
    SET Amortiza_Acumula	:= 4;
    SET MonedaID			:= 1;
	SET	Nat_Cargo			:= 'C';				-- Naturaleza Cargo

	SET	Nat_Abono			:= 'A';				-- Naturaleza Abono
    SET Est_Aplicado		:= 'A';
    SET Est_Vigente			:= 'VI';
    SET Est_Baja			:= 'BA';

    ManejoErrores: BEGIN
		DECLARE EXIT HANDLER FOR SQLEXCEPTION
			BEGIN
				SET Par_NumErr = 999;
				SET Par_ErrMen = CONCAT('El SAFI ha tenido un problema al concretar la operacion. Disculpe las molestias que ',
					 'esto le ocasiona. Ref: SP-APLICADEPAMORTIZAACTIVOSPRO');

				SET Var_Control = 'SQLEXCEPTION' ;

			END;

		-- Asignacion de Variables
		SET Var_FechaInicio 	:= CONVERT(CONCAT(CONVERT(Par_Anio, CHAR), '-',CONVERT(Par_Mes, CHAR),'-', '1'), DATE);
		SET Var_FechaFin 		:= CONVERT(DATE_SUB(DATE_ADD(Var_FechaInicio, INTERVAL 1 MONTH ), INTERVAL 1 DAY ), DATE);
		SET Var_FechaSistema	:=(SELECT Fechasistema FROM PARAMETROSSIS LIMIT 1);
        SET Var_AltaEncPol		:= Cons_NO;

        -- VALIDA SI YA SE REALIZO EL PROCESO DE DEPRECIACION
		IF EXISTS(SELECT BitApliDepAmoID FROM BITACORAAPLICDEPAMO WHERE Anio = Par_Anio AND Mes = Par_Mes)THEN

            SELECT Clave, Fecha, Hora
				INTO Var_Clave, Var_Fecha, Var_Hora
            FROM BITACORAAPLICDEPAMO BITA
				INNER JOIN USUARIOS USUA
					ON BITA.UsuarioID = USUA.UsuarioID
            WHERE Anio = Par_Anio
				AND Mes = Par_Mes;

			SET Par_NumErr 		:= 1;
			SET Par_ErrMen 		:= CONCAT('El proceso de Depreciacion y Amortizacion fue Realizado por ', Var_Clave ,' el ',Var_Fecha,' ',Var_Hora);
			SET Var_Control		:= 'anio';
			SET Var_Consecutivo	:= Entero_Cero;
			LEAVE ManejoErrores;

        END IF;

        -- REALIZA MOVIMIENTO CONTABLE QUE CORRESPONDE A LA AMORTIZACION O DEPRECIACION APLICADA A DETALLE
        -- POR CADA ACTIVO REGISTRADO EN EL SISTEMA.
		OPEN CURSORACTIVOSDEPREAMOR;
			BEGIN
				DECLARE EXIT HANDLER FOR SQLSTATE '02000' BEGIN END;
				CICLOCURSOR:LOOP
						FETCH CURSORACTIVOSDEPREAMOR INTO
							Var_DepreAmortiID,	Var_ActivoID,	Var_TipoActivoID,	Var_MontoDepreciar,		Var_ClasificaActivoID,
                            Var_DepreAcumuIni,	Var_TotalDepreIni;

						START TRANSACTION;
						Transaccion:BEGIN

							DECLARE EXIT HANDLER FOR SQLEXCEPTION SET Error_Key = 1;
							DECLARE EXIT HANDLER FOR SQLSTATE '23000' SET Error_Key = 2;
							DECLARE EXIT HANDLER FOR SQLSTATE '42000' SET Error_Key = 3;
							DECLARE EXIT HANDLER FOR SQLSTATE '22004' SET Error_Key = 4;
							DECLARE EXIT HANDLER FOR NOT FOUND SET Error_Key = 1;

							SET Aud_FechaActual := NOW();

                            -- SI LA CLASIFICACION DEL ACTIVO ES 1 SIGNIFCA QUE ES UN ACTIVO FIJO, SE AFECTAN LAS CUENTAS DE DEPRECIACION
                            IF(Var_ClasificaActivoID = 1)THEN

								-- Cargo Depreciacion Mensual
								CALL `CONTADEPREAMORTIPRO`(
									Var_ActivoID,       Var_TipoActivoID,       Deprecia_Mensual,	Var_FechaSistema,   Par_SucursalID,
									Var_ActivoID,   	MonedaID,  				Var_MontoDepreciar, Entero_Cero,		Var_AltaEncPol,
									Cons_SI,			Nat_Cargo,     			Par_Anio,			Par_Mes,			Par_PolizaID,
									Salida_NO,			Par_NumErr, 			Par_ErrMen, 		Par_EmpresaID,	    Aud_Usuario,
									Aud_FechaActual,    Aud_DireccionIP,    	Aud_ProgramaID,
									Aud_Sucursal,       Aud_NumTransaccion
								);

								IF(Par_NumErr <> Entero_Cero)THEN
									SET Error_Key := 99;
									LEAVE Transaccion;
								END IF;

								-- Abono Depreciacion Acumulada
								CALL `CONTADEPREAMORTIPRO`(
									Var_ActivoID,       Var_TipoActivoID,       Deprecia_Acumula,	Var_FechaSistema,   Par_SucursalID,
									Var_ActivoID,   	MonedaID,        		Var_MontoDepreciar, Entero_Cero,		Var_AltaEncPol,
									Cons_SI,			Nat_Abono,    			Par_Anio,			Par_Mes,			Par_PolizaID,
									Salida_NO,			Par_NumErr, 			Par_ErrMen, 		Par_EmpresaID,	    Aud_Usuario,
									Aud_FechaActual,    Aud_DireccionIP,    	Aud_ProgramaID,
									Aud_Sucursal,       Aud_NumTransaccion
								);

								IF(Par_NumErr <> Entero_Cero)THEN
									SET Error_Key := 99;
									LEAVE Transaccion;
								END IF;

                             ELSE -- SINO SE AFECTAN LAS CUENTAS DE AMORTIZACION

								-- Cargo Amortizacion Mensual
								CALL `CONTADEPREAMORTIPRO`(
									Var_ActivoID,       Var_TipoActivoID,       Amortiza_Mensual,	Var_FechaSistema,   Par_SucursalID,
									Var_ActivoID,   	MonedaID,        		Var_MontoDepreciar, Entero_Cero,		Var_AltaEncPol,
									Cons_SI,			Nat_Cargo,       		Par_Anio,			Par_Mes,			Par_PolizaID,
									Salida_NO,			Par_NumErr, 			Par_ErrMen, 		Par_EmpresaID,	    Aud_Usuario,
									Aud_FechaActual,    Aud_DireccionIP,    	Aud_ProgramaID,
									Aud_Sucursal,       Aud_NumTransaccion
								);

								IF(Par_NumErr <> Entero_Cero)THEN
									SET Error_Key := 99;
									LEAVE Transaccion;
								END IF;

								-- Abono Amortizacion Acumulada
								CALL `CONTADEPREAMORTIPRO`(
									Var_ActivoID,       Var_TipoActivoID,       Amortiza_Acumula,	Var_FechaSistema,   Par_SucursalID,
									Var_ActivoID,   	MonedaID,        		Var_MontoDepreciar, Entero_Cero,		Var_AltaEncPol,
									Cons_SI,			Nat_Abono,    			Par_Anio,			Par_Mes,			Par_PolizaID,
									Salida_NO,			Par_NumErr, 			Par_ErrMen, 		Par_EmpresaID,	    Aud_Usuario,
									Aud_FechaActual,    Aud_DireccionIP,    	Aud_ProgramaID,
									Aud_Sucursal,       Aud_NumTransaccion
								);

								IF(Par_NumErr <> Entero_Cero)THEN
									SET Error_Key := 99;
									LEAVE Transaccion;
								END IF;

                            END IF;

							-- ACTUALIZA BITACORA DE DEPRECIACION Y AMORTIZACION
							UPDATE BITACORADEPREAMORTI SET
								DepreAcuInicio = Var_DepreAcumuIni,
                                TotalDepreciarIni = Var_TotalDepreIni,
								Estatus = Est_Aplicado,
                                UsuarioID = Par_UsuarioID,
								SucursalID = Par_SucursalID,
                                FechaAplicacion = Var_FechaSistema,

								EmpresaID			= Par_EmpresaID,
								Usuario				= Aud_Usuario,
								FechaActual			= Aud_FechaActual,
								DireccionIP			= Aud_DireccionIP,
								ProgramaID			= Aud_ProgramaID,
								Sucursal			= Aud_Sucursal,
								NumTransaccion		= Aud_NumTransaccion
							WHERE DepreAmortiID = Var_DepreAmortiID
								AND ActivoID = Var_ActivoID;

							-- ACTUALIZA MONTOS DEPRCIACION DEL ACTIVO
                            UPDATE ACTIVOS SET
								DepreciadoAcumulado = DepreciadoAcumulado + Var_MontoDepreciar,
                                TotalDepreciar = TotalDepreciar - Var_MontoDepreciar,
                                EsDepreciado = Cons_SI,

								EmpresaID			= Par_EmpresaID,
								Usuario				= Aud_Usuario,
								FechaActual			= Aud_FechaActual,
								DireccionIP			= Aud_DireccionIP,
								ProgramaID			= Aud_ProgramaID,
								Sucursal			= Aud_Sucursal,
								NumTransaccion		= Aud_NumTransaccion
							WHERE ActivoID = Var_ActivoID;

                            SET Error_Key := 0;

						END Transaccion;

						IF Error_Key = 0 THEN
							COMMIT;
						ELSE
							ROLLBACK;
                            LEAVE ManejoErrores;
						END IF;

				END LOOP CICLOCURSOR;
			END;
		CLOSE CURSORACTIVOSDEPREAMOR;

		-- ALTA EN BITACORA DE APLICACION DE DEPRECIACION Y AMORTIZACION DE ACTIVOS POR MES Y ANIO
		CALL `BITACORAAPLICDEPAMOALT`(
			Par_Anio, 			Par_Mes,			Var_FechaSistema,	DATE_FORMAT(NOW( ), "%H:%i:%s" ),			Par_UsuarioID,
			Par_SucursalID,		Par_PolizaID,
			Salida_NO, 			Par_NumErr, 		Par_ErrMen, 		Par_EmpresaID,      Aud_Usuario,
			Aud_FechaActual,    Aud_DireccionIP,   	Aud_ProgramaID,		Aud_Sucursal,       Aud_NumTransaccion
		);

        IF(Par_NumErr <> Entero_Cero)THEN
			LEAVE ManejoErrores;
        END IF;

		SET	Par_NumErr 	:= Entero_Cero;
		SET	Par_ErrMen 	:= 'Aplicacion Depreciacion y Amortizacion Activos realizado Exitosamente.';
		SET Var_Control	:= 'anio' ;

    END ManejoErrores; -- END del Handler de Errores

	 IF(Par_Salida = Salida_SI) THEN
		SELECT  Par_NumErr AS NumErr,
				Par_ErrMen AS ErrMen,
				Var_Control AS control,
				Entero_Cero AS consecutivo;
		END IF;

END TerminaStore$$