
-- CREPASFLUCCAMBIOPRO
DELIMITER ;
DROP PROCEDURE IF EXISTS `CREPASFLUCCAMBIOPRO`;
DELIMITER $$

CREATE PROCEDURE `CREPASFLUCCAMBIOPRO`(
	/* Sp que genera la conta de la fluctración cambiaria*/
	Par_Fecha          DATE,
	Par_EmpresaID      INT(11),
  
	Aud_Usuario        INT(11),
	Aud_FechaActual    DATETIME,
	Aud_DireccionIP    VARCHAR(15),
	Aud_ProgramaID     VARCHAR(50),
	Aud_Sucursal       INT(11),
	Aud_NumTransaccion BIGINT(20)
	)
TerminaStore: BEGIN

	/* DECLARACION DE CONSTANTES*/
	DECLARE	Cadena_Vacia		CHAR(1);
	DECLARE	Fecha_Vacia			DATE;
	DECLARE	Entero_Cero			INT(11);
	DECLARE Nat_Cargo			CHAR(1);
	DECLARE Nat_Abono			CHAR(1);
	DECLARE Var_Nat1			CHAR(1);
	DECLARE Var_Nat2			CHAR(1);
	DECLARE Des_CieDia			VARCHAR(100);
	DECLARE Ref_GenIntMor		VARCHAR(50);
	DECLARE Ref_GenCap			VARCHAR(50);
	DECLARE Ref_GenInt			VARCHAR(50);
	DECLARE AltaPoliza_NO		CHAR(1);
	DECLARE AltaMovTes_NO 		CHAR(1);
	DECLARE AltaMovCre_SI 		CHAR(1);
	DECLARE AltaPolCre_SI		CHAR(1);
	DECLARE Var_SalidaNO 		CHAR(1);
	DECLARE Mov_FlucCapGan      INT(11);
	DECLARE Mov_FlucIntGan      INT(11);
	DECLARE Mov_FlucMorGan      INT(11);
	DECLARE Mov_FlucCorMorGan   INT(11);
	DECLARE Mov_FlucCapPer      INT(11);
	DECLARE Mov_FlucIntPer      INT(11);
	DECLARE Mov_FlucMorPer      INT(11);
	DECLARE Mov_FlucCorMorPer   INT(11);
	DECLARE Pol_Automatica      CHAR(1);
	DECLARE Con_GenFluctuacion  INT(11);      		-- Concepto Contable: Generacion de Fluctuación en Moneda Pasiva  tabla. CONCEPTOSCONTA
	DECLARE Enc_PolFluctuacion  VARCHAR(50);
	DECLARE Mov_IntMor          INT(11);
	DECLARE Var_ConcepFonCap	INT(11);    		/* concepto de capital que corresponde con la tabla CONCEPTOSFONDEO*/
	DECLARE AltaMovCre_NO		CHAR(1);
	DECLARE Mov_CapVigente		INT(4);     		-- Tipo del Movimiento de Credito Pasivo: Capital Vigente (TIPOSMOVSFONDEO)
	DECLARE Con_IntDeven		INT(11);			-- Concepto Contable: Interes Devengado .- CONCEPTOSFONDEO
	DECLARE NO_CobraISR     	CHAR(1);
	DECLARE Con_EgrIntExc   	INT(11);			-- Concepto Contable: Resultados. Egresos por  Interes .- CONCEPTOSFONDEO
	DECLARE Con_EgrIntGra   	INT(11);
	DECLARE Con_CueOrdMor		INT(11);
	DECLARE Con_CorOrdMor		INT(11);

	/* DECLARACION DE VARIABLES*/
	DECLARE	Var_FechaBatch      	DATE;
	DECLARE	Var_FecBitaco       	DATETIME;
	DECLARE	Var_MinutosBit 	    	INT(11);
	DECLARE Var_Control         	VARCHAR(100);
	DECLARE Var_EstatusFondVig  	CHAR(1);
	DECLARE Var_MonedaNaID      	INT(11);
	DECLARE Var_TotalRegistros  	INT(11);
	DECLARE Var_CountIni        	INT(11);
	DECLARE Var_FecApl          	DATE;           /* Fecha de Aplicacion */
	DECLARE Par_Consecutivo     	BIGINT;         /* Consecutivo */
	DECLARE Par_NumErr          	INT(11);        /* numero de error */
	DECLARE Par_ErrMen          	VARCHAR(400);   /* mensaje de error  */
	DECLARE Var_CreditoFondeoID 	BIGINT(11);
	DECLARE Var_MonedaID        	INT(11);
	DECLARE Var_InstitutFondID  	INT(11);
	DECLARE Var_PlazoContable   	CHAR(1);
	DECLARE Var_TipoInstitID    	INT(11);
	DECLARE Var_NacionalidadIns 	CHAR(1);
	DECLARE Var_TipoFondeador   	CHAR(1);
	DECLARE Var_SaldoCapVigente 	DECIMAL(14,4);
	DECLARE Var_SaldoInteresPro 	DECIMAL(14,4);
	DECLARE Var_SaldoMoratorios 	DECIMAL(14,4);
	DECLARE Var_InstitucionID   	INT(11);
	DECLARE Var_LineaFondeoID   	INT(11);
	DECLARE Var_FlucCapital         DECIMAL(14,4);
	DECLARE Var_FlucInteres         DECIMAL(14,4);
	DECLARE Var_FlucMoratorios      DECIMAL(14,4);
	DECLARE Var_Monto				DECIMAL(14,4);
	DECLARE Var_Poliza              BIGINT(20);       /* numero de poliza */
	DECLARE Par_SalidaNO            CHAR(1);
	DECLARE Var_ConCOMora           INT(11);
	DECLARE Var_ConCoCrMora         INT(11);
	DECLARE Var_ConCapital          INT(11);
	DECLARE Var_ConInteres          INT(11);
	DECLARE Cons_MonedaNID          INT(11);      -- Identificador de moneda nacional
	DECLARE Var_NumCtaInstit        VARCHAR(20);
	DECLARE Var_Descripcion1        VARCHAR(100);
	DECLARE Var_Descripcion2        VARCHAR(100);
	DECLARE Var_DescPasCap          VARCHAR(80);
	DECLARE Var_DescFlucCapPer      VARCHAR(80);
	DECLARE Var_DescPasIntOr        VARCHAR(80);
	DECLARE Var_DescFlucIntPer      VARCHAR(80);
	DECLARE Var_DescFlucCapGan      VARCHAR(80);
	DECLARE Var_DescFlucIntGan      VARCHAR(80);
	DECLARE Var_EsHabil				CHAR(1);
	DECLARE Var_CobraISR			CHAR(1);
	DECLARE Con_Egreso          	INT(11);
	DECLARE Var_Instrumento			VARCHAR(20);


	/* ASIGNACION DE CONSTANTES*/
	SET Cadena_Vacia        := '';
	SET Fecha_Vacia         := '1900-01-01';
	SET Entero_Cero         := 0;
	SET Var_EstatusFondVig  := 'N';
	SET Var_MonedaNaID      := 1;
	SET Nat_Cargo           := 'C';                                  /* Naturaleza de Cargo */
	SET Nat_Abono           := 'A';                                  /* Naturaleza de Abono */
	SET Aud_ProgramaID      := 'CREPASFLUCCAMBIOPRO';
	SET Pol_Automatica      := 'A';                                 -- Tipo de Poliza: Automatica
	SET Con_GenFluctuacion  := 1105;                                -- Concepto Contable: Generacion de Fluctuación en Moneda Pasiva  tabla. CONCEPTOSCONTA
	SET Enc_PolFluctuacion  := 'FLUCTUACION CAMBIARIA EN MONEDA PASIVA';
	SET Var_ConcepFonCap    := 1;                                   /* concepto de capital que corresponde con la tabla CONCEPTOSFONDEO*/
	SET AltaMovCre_NO       := 'N';                               -- Alta del Movimiento de Credito: NO

	Set Var_SalidaNO        := 'N';                               -- El store no Arroja una Salida
	SET AltaPolCre_SI       := 'S';                               -- Alta de la Poliza de Credito: SI
	SET AltaMovCre_SI       := 'S';                               -- Alta del Movimiento de Credito: NO
	SET AltaMovTes_NO       := 'N';                               -- Alta del Movimiento de Ahorro: NO
	SET AltaPoliza_NO       := 'N';                               -- Alta del Encabezado de la Poliza: NO
	SET Des_CieDia          := 'CIERRE DIARO CARTERA';
	SET Ref_GenIntMor       := 'GENERACION INTERES MORATORIO';
	SET Ref_GenCap          := 'GENERACION CAPITAL';
	SET Ref_GenInt          := 'GENERACION INTERES';
	SET Mov_IntMor          := 15;                                	-- Tipo de Movimiento de Credito Pasivo: Interes Moratorio .- CONCEPTOSFONDEO
	SET Mov_FlucCapGan      := 20;                                	-- Tipo de Movimiento de Credito Pasivo: Fluctuación Cap. (Ganancia)  - CONCEPTOSFONDEO
	SET Mov_FlucCapPer      := 21;                                	-- Tipo de Movimiento de Credito Pasivo: Fluctuación Cap. (Pérdida) - CONCEPTOSFONDEO
	SET Mov_FlucIntGan      := 22;                                	-- Tipo de Movimiento de Credito Pasivo: Fluctuación Int. (Ganancia)  - CONCEPTOSFONDEO
	SET Mov_FlucIntPer      := 23;                                	-- Tipo de Movimiento de Credito Pasivo: Fluctuación Int. (Pérdida)  - CONCEPTOSFONDEO
	SET Mov_FlucMorGan      := 24;                                	-- Tipo de Movimiento de Credito Pasivo: Fluctuación C.O. Mora (Ganancia) - CONCEPTOSFONDEO
	SET Mov_FlucMorPer      := 25;                                	-- Tipo de Movimiento de Credito Pasivo: Fluctuación C.O. Mora (Pérdida) - CONCEPTOSFONDEO
	SET Mov_FlucCorMorGan   := 26;                                	-- Tipo de Movimiento de Credito Pasivo: Fluctuación C.O. Corr Mora (Ganancia) - CONCEPTOSFONDEO
	SET Mov_FlucCorMorPer   := 27;                                	-- Tipo de Movimiento de Credito Pasivo: Fluctuación C.O. Corr Mora (Pérdida) - CONCEPTOSFONDEO
	SET Cons_MonedaNID      := 1;                                 	-- Asignación de moneda nacional 
	SET Mov_CapVigente      := 1;                                 	-- Tipo del Movimiento de Credito Pasivo: Capital Vigente (TIPOSMOVSFONDEO)
	SET Con_IntDeven		:= 8;									-- Concepto Contable: Interes Devengado .- CONCEPTOSFONDEO
	SET Var_DescPasCap      := 'PASIVO - CAPITAL M.N.';
	SET Var_DescFlucCapPer  := 'FLUCTUACIÓN CAP. (PÉRDIDA)';
	SET Var_DescPasIntOr    := 'PASIVO - INT. ORDINARIO M.N.';
	SET Var_DescFlucIntPer  := 'FLUCTUACIÓN INT. (PÉRDIDA)';
	SET NO_CobraISR     	:= 'N';         						-- No Cobra ISR
	SET Con_EgrIntExc		:= 3;									-- Concepto Contable: Resultados. Egresos por Interes Excento
	SET Con_EgrIntGra		:= 4;									-- Concepto Contable: Resultados. Egresos por Interes Gravado
	SET Con_CueOrdMor		:= 13;									-- Concepto Contable: Cuentas de Orden de Moratorios.- CONCEPTOSFONDEO
	SET Con_CorOrdMor		:= 14;									-- Concepto Contable: Correlativa de Orden de Moratorios .- CONCEPTOSFONDEO

	/* ASIGNACION DE VARIABLES*/
	SET	Var_FecBitaco	:= now();

	SET Aud_FechaActual:=now();

	ManejoErrores: BEGIN
		DECLARE EXIT HANDLER FOR SQLEXCEPTION BEGIN
			SET Par_NumErr	:= 999;
			SET Par_ErrMen	:= CONCAT('El SAFI ha tenido un problema al concretar la operación. ',
								'Disculpe las molestias que esto le ocasiona. Ref: SP-CREPASFLUCCAMBIOPRO');
			SET Var_Control := 'sqlException';
		END;

		CALL DIASFESTIVOSCAL(
			Par_Fecha,			Entero_Cero,		Var_FecApl,			Var_EsHabil,		Par_EmpresaID,
			Aud_Usuario,		Aud_FechaActual,	Aud_DireccionIP,	Aud_ProgramaID,		Aud_Sucursal,
			Aud_NumTransaccion
		);

		-- TABLA TMP PARA REGISTRO DE TIPO DE CAMBIO EN FECHA MAS RECIENTES
		DROP TABLE IF EXISTS TMP_MONEDAACT;
		CREATE TEMPORARY TABLE TMP_MONEDAACT(
			RegistroID bigint UNSIGNED AUTO_INCREMENT PRIMARY KEY,
			MonedaID  INT(11),
			TipCamDof DECIMAL(14,6)
		);

		-- TABLA TMP PARA REGISTRO DE TIPO DE CAMBIO EN LA FECHA ANTES DE ACTUALIZACIÓN MAS RECIENTE DE LA TABLA MONEDAS
		DROP TABLE IF EXISTS TMP_MONEDAANT;
		CREATE TEMPORARY TABLE TMP_MONEDAANT(
			RegistroID bigint UNSIGNED AUTO_INCREMENT PRIMARY KEY,
			MonedaId        INT(11),
			TipCamDof       DECIMAL(14,6)
		);

		-- TABLA TMP DE PASO REGISTROS DE TABLA CREDITOFONDEO CON CALCULOS
		DROP TABLE IF EXISTS TMP_CREDITOFONDEO;
		CREATE TABLE TMP_CREDITOFONDEO(
			RegistroID bigint UNSIGNED AUTO_INCREMENT PRIMARY KEY,
			CreditoFondeoID   BIGINT(20),
			MonedaId          INT(11),
			InstitutFondID    INT(11),
			PlazoContable     CHAR(1),
			TipoInstitID      INT(11),
			NacionalidadIns   CHAR(1),
			TipoFondeador     CHAR(1),
			InstitucionID     INT(11),
			LineaFondeoID     INT(11),
			NumCtaInstit      VARCHAR(20),
			SaldoCapVigente   DECIMAL(14,4),
			SaldoInteresPro   DECIMAL(14,4),
			SaldoMoratorios   DECIMAL(14,4),
			FlucCapital       DECIMAL(14,4),
			FlucInteres       DECIMAL(14,4),
			FlucMoratorios    DECIMAL(14,4),
			CobraISR 		  CHAR(1)
		);

		-- ALMACENADO DE REGISTROS DE LA TABLA MONEDAS A TMP
		INSERT INTO TMP_MONEDAACT (MonedaID,					TipCamDof)
			SELECT MonedaID, TipCamDof FROM MONEDAS;

		-- ALMACENDADO DE REGISTROS DE LA TABLA HIS-MONEDAS A TMP
		INSERT INTO TMP_MONEDAANT (MonedaId,					TipCamDof)
			SELECT MonedaId, FN_MONTIPOCAMBIOANT(MonedaId,Par_Fecha) AS TipCamDof
			FROM MONEDAS;

		INSERT INTO TMP_CREDITOFONDEO ( CreditoFondeoID,  MonedaId,         SaldoCapVigente,  SaldoInteresPro,  SaldoMoratorios,
										FlucCapital,      FlucInteres,      FlucMoratorios,   InstitutFondID,   PlazoContable,
										TipoInstitID,     NacionalidadIns,  TipoFondeador,    InstitucionID,    LineaFondeoID,
										NumCtaInstit,		CobraISR)
			SELECT  CRE.CreditoFondeoID, CRE.MonedaID, CRE.SaldoCapVigente, CRE.SaldoInteresPro, CRE.SaldoMoratorios, 
					((CRE.SaldoCapVigente + CRE.SaldoCapAtrasad) * ACT.TipCamDof) - ((CRE.SaldoCapVigente + CRE.SaldoCapAtrasad) * ANT.TipCamDof) FlucCap,
					((CRE.SaldoInteresAtra + CRE.SaldoInteresPro) * ACT.TipCamDof) - ((CRE.SaldoInteresAtra + CRE.SaldoInteresPro)  * ANT.TipCamDof) FlucInt,
					(CRE.SaldoMoratorios * ACT.TipCamDof) - (CRE.SaldoMoratorios  * ANT.TipCamDof) FlucMora,  CRE.InstitutFondID, CRE.PlazoContable,
					CRE.TipoInstitID,   CRE.NacionalidadIns,  CRE.TipoFondeador, CRE.InstitucionID, CRE.LineaFondeoID,
					CRE.NumCtaInstit, CRE.CobraISR
				FROM CREDITOFONDEO CRE
				INNER JOIN TMP_MONEDAACT ACT ON ACT.MonedaID = CRE.MonedaID
				inner JOIN TMP_MONEDAANT ANT ON ANT.MonedaID = CRE.MonedaID
				WHERE CRE.Estatus = Var_EstatusFondVig
				AND CRE.MonedaID <> Var_MonedaNaID
				AND CRE.FechaInicio < Par_Fecha;

		SELECT COUNT(CreditoFondeoID) 
			INTO Var_TotalRegistros
		FROM TMP_CREDITOFONDEO;

		IF (Var_TotalRegistros > Entero_Cero) then/* Si hay creditos que entren en las condiciones*/
			call MAESTROPOLIZAALT(/*se da de alta el encabezado de la poliza */
				Var_Poliza,       Par_EmpresaID,  Var_FecApl,     Pol_Automatica,     Con_GenFluctuacion,
				Enc_PolFluctuacion, Par_SalidaNO,   Aud_Usuario,    Aud_FechaActual,    Aud_DireccionIP,
				Aud_ProgramaID,   Aud_Sucursal,   Aud_NumTransaccion);
		END IF;

		SET Var_CountIni := 0;
		WHILE Var_CountIni < Var_TotalRegistros DO

			SELECT  	CreditoFondeoID,      	MonedaId,           	InstitutFondID,       	PlazoContable,        	TipoInstitID,
						NacionalidadIns,      	TipoFondeador,      	SaldoCapVigente,      	SaldoInteresPro,      	SaldoMoratorios,
						FlucCapital,          	FlucInteres,        	FlucMoratorios,       	InstitucionID,        	LineaFondeoID,
						NumCtaInstit,			CobraISR
				INTO  	Var_CreditoFondeoID,	Var_MonedaID,			Var_InstitutFondID,   	Var_PlazoContable,    	Var_TipoInstitID,
						Var_NacionalidadIns, 	Var_TipoFondeador,  	Var_SaldoCapVigente,  	Var_SaldoInteresPro,  	Var_SaldoMoratorios,
						Var_FlucCapital,  		Var_FlucInteres,    	Var_FlucMoratorios,   	Var_InstitucionID,    	Var_LineaFondeoID,
						Var_NumCtaInstit, 		Var_CobraISR
				FROM TMP_CREDITOFONDEO
				LIMIT Var_CountIni,1;

			SET Var_CobraISR    := IFNULL(Var_CobraISR, NO_CobraISR);

			-- SECCION CAPITAL
			IF(Var_FlucCapital <> 0)THEN
				IF(Var_FlucCapital > 0)THEN
					SET Var_Nat1 := Nat_Abono;  -- (Pasivo - Capital M.N.) (Abono)
					SET Var_Nat2 := Nat_Cargo;  
					SET Var_ConCapital := Mov_FlucCapPer; -- (Fluctuación Cap. (Pérdida)) (Cargo)
				ELSE
					SET Var_FlucCapital := Var_FlucCapital * -1; -- Capital se convierte valor positivo
					SET Var_Nat1 := Nat_Cargo;  -- (Pasivo - Capital M.N.) (Cargo)
					SET Var_Nat2 := Nat_Abono;
					SET Var_ConCapital := Mov_FlucCapGan; -- -- (Fluctuación Cap. (Ganancia))(Abono)
				END IF;

				SET Var_Instrumento := CONVERT(Var_CreditoFondeoID, CHAR);

				-- Se inserta registro contable de Capital en Moneda Nacional
				CALL CONTAFONDEOPRO(
					Cons_MonedaNID,                     Var_LineaFondeoID,                  Var_InstitutFondID,   Var_InstitucionID,    Var_NumCtaInstit,
					Var_CreditoFondeoID,                Var_PlazoContable,                  Var_TipoInstitID,     Var_NacionalidadIns,  Var_ConcepFonCap,
					Des_CieDia,                   		Par_Fecha,                          Var_FecApl,           Var_FecApl,           Var_FlucCapital,
					CONVERT(Var_CreditoFondeoID,CHAR),  Var_Instrumento,  					AltaPoliza_NO,        Entero_Cero,         	Var_Nat1, 
					Nat_Cargo,                          Nat_Cargo,                          Nat_Abono,            AltaMovTes_NO,        Cadena_Vacia,
					AltaMovCre_NO,                      Entero_Cero,                        Mov_CapVigente,       AltaPolCre_SI,        Var_TipoFondeador,
					Var_SalidaNO,                       Var_Poliza,                         Par_Consecutivo,      Par_NumErr,           Par_ErrMen,
					Par_EmpresaID,                      Aud_Usuario,                        Aud_FechaActual,      Aud_DireccionIP,      Aud_ProgramaID,
					Aud_Sucursal,                       Aud_NumTransaccion
				);

				-- si sucedio un error se sale del sp
				IF(Par_NumErr <> Entero_Cero) THEN 
					LEAVE ManejoErrores;
				END IF;

				-- Si la fluctuacion es positiva es un cargo
				-- Se inserta registro contable de Capital en Moneda Nacional 
				CALL CONTAFONDEOPRO(
					Cons_MonedaNID,                     Var_LineaFondeoID,                  Var_InstitutFondID,   Var_InstitucionID,    Var_NumCtaInstit,
					Var_CreditoFondeoID,                Var_PlazoContable,                  Var_TipoInstitID,     Var_NacionalidadIns,  Var_ConCapital,
					Des_CieDia,                   		Par_Fecha,                          Var_FecApl,           Var_FecApl,           Var_FlucCapital,
					CONVERT(Var_CreditoFondeoID,CHAR),  Var_Instrumento,  					AltaPoliza_NO,        Entero_Cero,         	Var_Nat2,
					Nat_Cargo,                          Nat_Cargo,                          Nat_Abono,            AltaMovTes_NO,        Cadena_Vacia,
					AltaMovCre_NO,                      Entero_Cero,                        Mov_CapVigente,       AltaPolCre_SI,        Var_TipoFondeador,
					Var_SalidaNO,                       Var_Poliza,                         Par_Consecutivo,      Par_NumErr,           Par_ErrMen,
					Par_EmpresaID,                      Aud_Usuario,                        Aud_FechaActual,      Aud_DireccionIP,      Aud_ProgramaID,
					Aud_Sucursal,                       Aud_NumTransaccion);
	
				-- si sucedio un error se sale del sp
				IF(Par_NumErr <> Entero_Cero) THEN 
					LEAVE ManejoErrores;
				END IF;
			END IF;
			
			
			-- SECCION INTERES ORDINARIO
			IF(Var_FlucInteres <> 0)THEN
				IF(Var_FlucInteres > 0)THEN -- Perdida
					SET Var_Nat1 := Nat_Abono;
					SET Var_Nat2 := Nat_Cargo;
					SET Var_ConInteres := Mov_FlucIntPer; -- Fluctuación Int. (Perdida)
				ELSE  -- Ganancia 
					SET Var_FlucInteres := Var_FlucInteres * -1; -- Capital se convierte valor positivo
					SET Var_Nat1 := Nat_Cargo;
					SET Var_Nat2 := Nat_Abono;
					SET Var_ConInteres := Mov_FlucIntGan; -- Fluctuación Int. (Ganancia)
				END IF;

				-- se generan los movimientos contables para egresos
				CALL CONTAFONDEOPRO( 
					Cons_MonedaNID,         			Entero_Cero,                Var_InstitutFondID, 	Entero_Cero,            Cadena_Vacia,
					Var_CreditoFondeoID,    			Var_PlazoContable,          Var_TipoInstitID,   	Var_NacionalidadIns,    Con_IntDeven,
					Des_CieDia,             			Par_Fecha,           		Var_FecApl,         	Var_FecApl,             Var_FlucInteres,
					CONVERT(Var_CreditoFondeoID,CHAR),  Var_Instrumento,    		AltaPoliza_NO,      	Entero_Cero,            Var_Nat1,
					Cadena_Vacia,           			Nat_Cargo,                  Cadena_Vacia,       	AltaMovTes_NO,          Cadena_Vacia,
					AltaMovCre_NO,          			Entero_Cero,         		Entero_Cero,         	AltaPolCre_SI,          Var_TipoFondeador,
					Var_SalidaNO,           			Var_Poliza,                 Par_Consecutivo,    	Par_NumErr,             Par_ErrMen,
					Par_EmpresaID,          			Aud_Usuario,                Aud_FechaActual,    	Aud_DireccionIP,        Aud_ProgramaID,
					Aud_Sucursal,          	 			Aud_NumTransaccion );
					
				IF(Par_NumErr <> Entero_Cero) THEN -- si sucedio un error se sale del sp
					LEAVE ManejoErrores;
				END IF;

				CALL CONTAFONDEOPRO( -- se generan los movimientos contables para Interes Devengado
					Cons_MonedaNID,						Entero_Cero,			Var_InstitutFondID,		Entero_Cero,			Cadena_Vacia,           
					Var_CreditoFondeoID,				Var_PlazoContable,		Var_TipoInstitID,		Var_NacionalidadIns,	Var_ConInteres,
					Des_CieDia,							Par_Fecha,				Var_FecApl,				Var_FecApl,				Var_FlucInteres,
					CONVERT(Var_CreditoFondeoID,CHAR),	Var_Instrumento,	AltaPoliza_NO,			Entero_Cero,			Var_Nat2,
					Cadena_Vacia,						Nat_Abono,				Cadena_Vacia,			AltaMovTes_NO,			Cadena_Vacia,
					AltaMovCre_NO,						Entero_Cero,			Entero_Cero,			AltaPolCre_SI,			Var_TipoFondeador,
					Var_SalidaNO,						Var_Poliza,				Par_Consecutivo,		Par_NumErr,				Par_ErrMen,
					Par_EmpresaID,						Aud_Usuario,			Aud_FechaActual,		Aud_DireccionIP,		Aud_ProgramaID,
					Aud_Sucursal,						Aud_NumTransaccion  );
			
				IF(Par_NumErr <> Entero_Cero) THEN -- si sucedio un error se sale del sp
					LEAVE ManejoErrores;
				END IF;

			END IF;

			-- SECCION INTERES MORATORIO
			IF(Var_FlucMoratorios <> 0) THEN
				IF(Var_FlucMoratorios > 0)THEN
					SET Var_Monto := Var_FlucMoratorios;
					SET Var_Nat1 := Nat_Cargo;
					SET Var_Nat2 := Nat_Abono;
					SET Var_ConCOMora := Mov_FlucMorPer;
				ELSE
					SET Var_Monto := Var_FlucMoratorios * -1;
					SET Var_Nat1 := Nat_Abono;
					SET Var_Nat2 := Nat_Cargo;
					SET Var_ConCOMora := Mov_FlucMorGan;
				END IF;

				/* se generan los movimientos contables y operativos para Cuentas de Orden de Moratorio  */
				CALL CONTAFONDEOPRO( 
					Cons_MonedaNID,         Entero_Cero,            Var_InstitutFondID,     Entero_Cero,          Cadena_Vacia,
					Var_CreditoFondeoID,    Var_PlazoContable,      Var_TipoInstitID,       Var_NacionalidadIns,  Con_CueOrdMor,
					Des_CieDia,             Par_Fecha,              Var_FecApl,             Var_FecApl,           Var_Monto,
					CONVERT(Var_CreditoFondeoID,CHAR), 				CONVERT(Var_CreditoFondeoID,CHAR),    AltaPoliza_NO,          Entero_Cero,          Var_Nat1,
					Cadena_Vacia,           Cadena_Vacia,           Cadena_Vacia,           AltaMovTes_NO,        Cadena_Vacia,
					AltaMovCre_NO,          EnteRo_cero,     		Entero_Cero,             AltaPolCre_SI,        Var_TipoFondeador,
					Var_SalidaNO,           Var_Poliza,             Par_Consecutivo,        Par_NumErr,           Par_ErrMen,
					Par_EmpresaID,          Aud_Usuario,            Aud_FechaActual,        Aud_DireccionIP,      Aud_ProgramaID,
					Aud_Sucursal,           Aud_NumTransaccion);
				
				-- si sucedio un error se sale del sp
				IF(Par_NumErr <> Entero_Cero) THEN 
					LEAVE ManejoErrores;
				END IF;

				/* se generan los movimientos contables y operativos para Cuentas de Orden de Moratorio  */
				CALL CONTAFONDEOPRO( 
					Cons_MonedaNID,         Entero_Cero,            Var_InstitutFondID,     Entero_Cero,          Cadena_Vacia,
					Var_CreditoFondeoID,    Var_PlazoContable,      Var_TipoInstitID,       Var_NacionalidadIns,  Var_ConCOMora,
					Des_CieDia,             Par_Fecha,              Var_FecApl,             Var_FecApl,           Var_Monto,
					CONVERT(Var_CreditoFondeoID,CHAR),				CONVERT(Var_CreditoFondeoID,CHAR),    AltaPoliza_NO,          Entero_Cero,          Var_Nat2,
					Cadena_Vacia,           Cadena_Vacia,           Cadena_Vacia,           AltaMovTes_NO,        Cadena_Vacia,
					AltaMovCre_NO,          EnteRo_cero,     		Entero_Cero,             AltaPolCre_SI,        Var_TipoFondeador,
					Var_SalidaNO,           Var_Poliza,             Par_Consecutivo,        Par_NumErr,           Par_ErrMen,
					Par_EmpresaID,          Aud_Usuario,            Aud_FechaActual,        Aud_DireccionIP,      Aud_ProgramaID,
					Aud_Sucursal,           Aud_NumTransaccion);
				
				-- si sucedio un error se sale del sp
				IF(Par_NumErr <> Entero_Cero) THEN 
					LEAVE ManejoErrores;
				END IF;

				IF(Var_FlucMoratorios > 0)THEN
					SET Var_Monto := Var_FlucMoratorios;
					SET Var_Nat1 := Nat_Abono;
					SET Var_Nat2 := Nat_Cargo;
					SET Var_ConCOMora := Mov_FlucCorMorPer;
				ELSE
					SET Var_Monto := Var_FlucMoratorios * -1;
					SET Var_Nat1 := Nat_Cargo;
					SET Var_Nat2 := Nat_Abono;
					SET Var_ConCOMora := Mov_FlucCorMorGan;
				END IF;

				-- /* se generan los movimientos contables para  Correlativa Cuentas de Orden de Moratorios */
				CALL CONTAFONDEOPRO( 
					Cons_MonedaNID,         Entero_Cero,            Var_InstitutFondID,     Entero_Cero,              Cadena_Vacia,
					Var_CreditoFondeoID,    Var_PlazoContable,      Var_TipoInstitID,       Var_NacionalidadIns,      Con_CorOrdMor,
					Des_CieDia,             Par_Fecha,              Var_FecApl,             Var_FecApl,               Var_Monto,
					CONVERT(Var_CreditoFondeoID,CHAR), 				CONVERT(Var_CreditoFondeoID,CHAR),    AltaPoliza_NO,          Entero_Cero,              Var_Nat1,
					Cadena_Vacia,           Cadena_Vacia,           Cadena_Vacia,           AltaMovTes_NO,            Cadena_Vacia,
					AltaMovCre_NO,          EnteRo_cero,     		Entero_Cero,             AltaPolCre_SI,            Var_TipoFondeador,
					Var_SalidaNO,           Var_Poliza,             Par_Consecutivo,        Par_NumErr,               Par_ErrMen,
					Par_EmpresaID,          Aud_Usuario,            Aud_FechaActual,        Aud_DireccionIP,          Aud_ProgramaID,
					Aud_Sucursal,           Aud_NumTransaccion);
				
				-- si sucedio un error se sale del sp
				IF(Par_NumErr != Entero_Cero) THEN
					LEAVE ManejoErrores;
				END IF;

				CALL CONTAFONDEOPRO( 
					Cons_MonedaNID,         Entero_Cero,            Var_InstitutFondID,     Entero_Cero,              Cadena_Vacia,
					Var_CreditoFondeoID,    Var_PlazoContable,      Var_TipoInstitID,       Var_NacionalidadIns,      Var_ConCOMora,
					Des_CieDia,             Par_Fecha,              Var_FecApl,             Var_FecApl,               Var_Monto,
					CONVERT(Var_CreditoFondeoID,CHAR),        		CONVERT(Var_CreditoFondeoID,CHAR),    AltaPoliza_NO,          Entero_Cero,              Var_Nat2,
					Cadena_Vacia,           Cadena_Vacia,           Cadena_Vacia,           AltaMovTes_NO,            Cadena_Vacia,
					AltaMovCre_NO,          EnteRo_cero,     		Entero_Cero,             AltaPolCre_SI,            Var_TipoFondeador,
					Var_SalidaNO,           Var_Poliza,             Par_Consecutivo,        Par_NumErr,               Par_ErrMen,
					Par_EmpresaID,          Aud_Usuario,            Aud_FechaActual,        Aud_DireccionIP,          Aud_ProgramaID,
					Aud_Sucursal,           Aud_NumTransaccion);
				
				-- si sucedio un error se sale del sp
				IF(Par_NumErr != Entero_Cero) THEN
					LEAVE ManejoErrores;
				END IF;
				
			END IF;

			SET Var_CountIni := Var_CountIni + 1;
		END WHILE;

		DROP TABLE IF EXISTS TMP_MONEDAACT;
		DROP TABLE IF EXISTS TMP_MONEDAANT;
		DROP TABLE IF EXISTS TMP_CREDITOFONDEO;
	END ManejoErrores;

END TerminaStore$$
