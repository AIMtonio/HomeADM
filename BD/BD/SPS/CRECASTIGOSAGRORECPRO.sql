-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- CRECASTIGOSAGRORECPRO
DELIMITER ;
DROP PROCEDURE IF EXISTS `CRECASTIGOSAGRORECPRO`;DELIMITER $$

CREATE PROCEDURE `CRECASTIGOSAGRORECPRO`(
/* SP PARA EL PROCESO CONTABLE DE LA RECUPERACION DE CARTERA CASTIGADA*/

    Par_CreditoID          BIGINT(12),          -- ID DEL CREDITO
    Par_CuentaAhoID        BIGINT(12),          -- Cuenta de Ahorro del Cliente
    Par_ClienteID          BIGINT(11),              -- Cliente
    Par_Monto              DECIMAL(14,2),       -- MONTO RECUPERADO
    Par_PolizaID           BIGINT(20),          -- POLIZA CONTABLE
    Par_DescripcionMov     VARCHAR(100),        -- OBSERVACIONES DEL CASTIGO
    Par_PorcentajeCast     DECIMAL(12,2),       -- PORCENTAJE DE PAGO PARA EL CREDITO ACTIVO
    Par_PorcentajeCastCont DECIMAL(12,2),       -- PORCENTAJE DE PARA PARA EL CREDITO CONTINGENTE


    Par_Salida             CHAR(1),
    OUT Par_NumErr         INT,
    OUT Par_ErrMen         VARCHAR(400),

    -- Parametros de Auditoria
    Par_EmpresaID           INT(11),        -- Parametro de auditoria ID de la empresa
    Aud_Usuario             INT(11),        -- Parametro de auditoria ID del usuario

    Aud_FechaActual         DATETIME,       -- Parametro de auditoria Fecha actual
    Aud_DireccionIP         VARCHAR(15),    -- Parametro de auditoria Direccion IP
    Aud_ProgramaID          VARCHAR(50),    -- Parametro de auditoria Programa
    Aud_Sucursal            INT(11),        -- Parametro de auditoria ID de la sucursal
    Aud_NumTransaccion      BIGINT(20)      -- Parametro de auditoria Numero de la transaccion
    )
TerminaStore:BEGIN

    -- Declaracion de Variables
    DECLARE Var_MonedaID        INT(11);
    DECLARE Var_ProductoCred    INT(11);
    DECLARE Var_ClasifCre       CHAR(1);
    DECLARE Var_SubClasifID     INT(11);
    DECLARE Var_SucursalCliente INT(11);
    DECLARE Var_Poliza          BIGINT;
    DECLARE Var_Control         VARCHAR(100);
    DECLARE Var_FechaAplicacion DATE;
    DECLARE Var_MontoRecuperado DECIMAL(14,2); -- MONTO QUE SE HA RECUPERADO DEL CREDITO
    DECLARE Var_PorRecuperar    DECIMAL(14,2);

    DECLARE Var_SaldoCapital    DECIMAL(14,2);
    DECLARE Var_SaldoInteres    DECIMAL(14,2);
    DECLARE Var_SaldoMoratorio  DECIMAL(14,2);
    DECLARE Var_SaldoAccesorios DECIMAL(14,2);
    DECLARE Var_SaldoRecupera   DECIMAL(14,2);  -- SALDO PENDIENTE POR APLICAR
    DECLARE Var_AplicaIVA       CHAR(1);
    DECLARE Var_TasaIVA         DECIMAL(12,2);
    DECLARE Var_IVAConcepto     DECIMAL(12,2);
	DECLARE SI_AplicaIVA        CHAR(1);

    -- Declaracion de Constantes
    DECLARE Entero_Cero         INT;
    DECLARE Decimal_Cero		DECIMAL(12,2);
    DECLARE Fecha_Vacia         DATE;
    DECLARE Descripcion         VARCHAR(100);
    DECLARE Cadena_Vacia        CHAR;

    DECLARE Nat_Abono           CHAR(1);
    DECLARE Nat_Cargo           CHAR(1);

    DECLARE Salida_SI           CHAR(1);
    DECLARE Salida_NO           CHAR(1);

    DECLARE Var_Contingente         CHAR(1);
    DECLARE Var_SaldoRecuperaCont   DECIMAL(14,2);  -- SALDO PENDIENTE POR APLICAR
    DECLARE VarCreditoCont          BIGINT;
    DECLARE Var_Consecutivo         BIGINT;

	DECLARE AltaPolizaSI        CHAR(1);
	DECLARE AltaPolizaNO        CHAR(1);
	DECLARE AltaEncPolisaSI     CHAR(1);
	DECLARE AltaEncPolisaNO     CHAR(1);

	DECLARE Mov_RecCartCast		VARCHAR(4);
	DECLARE Con_RecCartera		INT(11);
    DECLARE Cliente				INT;
	DECLARE SaldoDisp			DECIMAL(12,2);
	DECLARE MonedaCon			INT;
	DECLARE EstatusC			CHAR(1);
    DECLARE Var_EstatusDes		VARCHAR(50);
	DECLARE EstatusActivo		CHAR(1);

	DECLARE Var_CapitalCont		 DECIMAL(12,2); --  CAPITAL CONTINGENTE APLICADO
    DECLARE Var_InteresCont		 DECIMAL(12,2); --  INTERES CONTINGENTE APLICADO
    DECLARE Var_MoratoriosCont	 DECIMAL(12,2); --  MORATORIO CONTINGENTE APLICADO
    DECLARE Var_ComisionCont 	 DECIMAL(12,2); --  COMISION CONTINGENTE APLICADO
    DECLARE Var_IVACont 		 DECIMAL(12,2); --  IVA CONTINGENTE APLICADO

	DECLARE Var_Capital			 DECIMAL(12,2); --  CAPITAL APLICADO
    DECLARE Var_Interes			 DECIMAL(12,2); --  INTERES APLICADO
    DECLARE Var_Moratorios		 DECIMAL(12,2); --  MORATORIO APLICADO
    DECLARE Var_Comision	 	 DECIMAL(12,2);	--  COMISION APLICADO
    DECLARE Var_IVA		 		 DECIMAL(12,2); --  IVA APLICADO

    DECLARE Var_TotalCapital	 DECIMAL(12,2); -- TOTAL CAPITAL  APLICADO
    DECLARE Var_TotalInteres	 DECIMAL(12,2); -- TOTAL INTERES  APLICADO
    DECLARE Var_TotalMoratorios	 DECIMAL(12,2); -- TOTAL MORATORIO  APLICADO
    DECLARE Var_TotalComision	 DECIMAL(12,2);	-- TOTAL COMISION  APLICADO
    DECLARE Var_TotalIVA		 DECIMAL(12,2); -- TOTAL IVA  APLICADO

    DECLARE Var_TotalAdeudo		 DECIMAL(12,2);	-- TOTAL ADEUDO
	DECLARE CON_Ticket			 BIGINT; 		-- CONSECUTIVO TICKET

	DECLARE Var_SaldoCapitalCont    DECIMAL(14,2);	-- SALDO CAPITAL CONTINGENTE
    DECLARE Var_SaldoInteresCont    DECIMAL(14,2);	-- SALDO INTERES CONTINGENTE
    DECLARE Var_SaldoMoratorioCont  DECIMAL(14,2);	-- SALDO MORATORIO CONTINGENTE
    DECLARE Var_SaldoAccesoriosCont DECIMAL(14,2);	-- SALDO ACCESORIOS CONTINGENTE
	DECLARE Var_PorRecuperarCont	DECIMAL(14,2); 	-- SALDO POR RECUPERAR DEL CONTINGENTE
	DECLARE Var_DivideCastigo   	CHAR(1);
    DECLARE Mov_Pasivo				INT(1);			-- CARGO CTA

    -- Asignacion de Constantes
    SET Entero_Cero         := 0;
    SET Fecha_Vacia         := '1900-01-01';
    SET Descripcion         := 'RECUPERACION DE CARTERA CASTIGADA';
    SET Cadena_Vacia        := '';

    SET Salida_SI           := 'S';
    SET Salida_NO           := 'N';
    SET Nat_Abono           := 'A';         -- Naturaleza Contable: Abono
    SET Nat_Cargo           := 'C';         -- Naturaleza Contable: Cargo

	SET AltaEncPolisaSI     := 'S';         -- Alta del Encabezado de la Poliza: SI
	SET AltaEncPolisaNO     := 'N';         -- Alta del Encabezado de la Poliza: NO
    SET AltaPolizaSI        := 'S';
	SET AltaPolizaNO        := 'N';

	SET Mov_Pasivo		  	:= '1';
	SET Mov_RecCartCast     :=  610;  -- RECUPERACION DE CARTERA CASTIGADA
	SET EstatusActivo		:= 'A';
	SET SaldoDisp			:= 0.0;
	SET Decimal_Cero		:= 0.0;
	SET SI_AplicaIVA        := 'S';         -- Si aplica IVA en la Recuperacion de Cartera Castigada.

ManejoErrores:BEGIN

    DECLARE EXIT HANDLER FOR SQLEXCEPTION
        BEGIN
            SET Par_NumErr  = 999;
            SET Par_ErrMen  = CONCAT('El SAFI ha tenido un problema al concretar la operacion. ',
                                'Disculpe las molestias que esto le ocasiona. Ref: SP-CRECASTIGOSAGRORECPRO');
            SET Var_Control = 'sqlException';
        END;


    -- NUMERO DE LA EMPRESA
    SET Par_EmpresaID := IFNULL(Par_EmpresaID, 1);

    -- FECHA DEL SISTEMA
    SET Var_FechaAplicacion :=(SELECT FechaSistema
                            FROM PARAMETROSSIS
                            WHERE EmpresaID = Par_EmpresaID);
    -- FECHA DE AUDITORIA
    SET Aud_FechaActual     := CURRENT_TIMESTAMP();

    IF NOT EXISTS(SELECT CreditoID
						FROM  CRECASTIGOS
							WHERE CreditoID = Par_CreditoID)THEN
        SET Par_NumErr  := 1;
        SET Par_ErrMen  :=CONCAT('El Credito ',Par_CreditoID,' no se Encuentra Castigado');
        SET Var_Control :='creditoID';
        LEAVE ManejoErrores;
    END IF;

    -- VERIFICAMOS SI EL CREDITO TIENE CONTINGENTE
    SET VarCreditoCont =(SELECT CreditoID FROM CRECASTIGOSCONT WHERE CreditoID = Par_CreditoID) ;
 -- DATOS GENERALES DEL CREDITO CASTIGADO
    SELECT   SaldoCapital,      SaldoInteres,     SaldoMoratorio,     SaldoAccesorios
        INTO Var_SaldoCapital,  Var_SaldoInteres, Var_SaldoMoratorio, Var_SaldoAccesorios
    FROM CRECASTIGOS
    WHERE CreditoID = Par_CreditoID;

     -- Inicializaciones
    SET Var_SaldoCapital    := IFNULL(Var_SaldoCapital, Decimal_Cero );
    SET Var_SaldoInteres    := IFNULL(Var_SaldoInteres, Decimal_Cero );
    SET Var_SaldoMoratorio  := IFNULL(Var_SaldoMoratorio, Decimal_Cero );
    SET Var_SaldoAccesorios := IFNULL(Var_SaldoAccesorios, Decimal_Cero );

    -- Consideraciones del IVA
    SET Var_TasaIVA := Entero_Cero;
    SET Var_AplicaIVA   := IFNULL(Var_AplicaIVA, SI_AplicaIVA);
    IF(Var_AplicaIVA = SI_AplicaIVA) THEN
        SELECT Suc.IVA INTO Var_TasaIVA
        FROM CREDITOS Cre,
             SUCURSALES Suc
        WHERE CreditoID = Par_CreditoID
          AND Cre.SucursalID = Suc.SucursalID;
    END IF;

    SET Var_TasaIVA      := IFNULL(Var_TasaIVA, Entero_Cero);

    SET Var_PorRecuperar :=  ROUND(Var_SaldoCapital * (1+Var_TasaIVA),2) +
                             ROUND(Var_SaldoInteres * (1+Var_TasaIVA),2) +
                             ROUND(Var_SaldoMoratorio * (1+Var_TasaIVA),2) +
                             ROUND(Var_SaldoAccesorios * (1+Var_TasaIVA),2);

    SELECT   Cre.MonedaID,    Cre.ProductoCreditoID, Des.Clasificacion,  Des.SubClasifID,  Cli.SucursalOrigen
        INTO Var_MonedaID,    Var_ProductoCred ,     Var_ClasifCre,      Var_SubClasifID,  Var_SucursalCliente
    FROM CREDITOS Cre,
          CLIENTES Cli,
        DESTINOSCREDITO Des
    WHERE CreditoID          = Par_CreditoID
      AND Cre.ClienteID      = Cli.ClienteID
     AND Cre.DestinoCreID   = Des.DestinoCreID;

    IF((Par_PorcentajeCast + Par_PorcentajeCastCont) > 100) THEN
		SET Par_NumErr  := 2;
		SET Par_ErrMen  :='La Suma de los Porcentajes No Puede Ser Mayor a 100%';
		SET Var_Control :='montoRecuperar';
		LEAVE ManejoErrores;
    ELSE
		IF((Par_PorcentajeCast + Par_PorcentajeCastCont) < 100) THEN
			SET Par_NumErr  := 3;
			SET Par_ErrMen  :='La Suma de los Porcentajes No Puede Ser Menor a 100%';
			SET Var_Control :='montoRecuperar';
			LEAVE ManejoErrores;

		ELSE

			IF((Par_PorcentajeCast + Par_PorcentajeCastCont) = 100) THEN
					CALL SALDOSAHORROCON(Cliente,  SaldoDisp,  MonedaCon,  EstatusC, Par_CuentaAhoID);

					IF(IFNULL(EstatusC, Cadena_Vacia)) = Cadena_Vacia THEN
						SET Par_NumErr		:= 4;
						SET Par_ErrMen		:= CONCAT('La Cuenta no Existe.');
						SET Var_Control		:= 'cuentaAhoID' ;
						SET Var_Consecutivo := '0';
						LEAVE ManejoErrores;
					END IF;

					IF (EstatusC  ='R')	THEN
						SET Var_EstatusDes :='REGISTRADA';
						ELSEIF(EstatusC ='A')THEN
							SET Var_EstatusDes :='ACTIVA';
							ELSEIF(EstatusC ='B') THEN
								SET Var_EstatusDes :='BLOQUEADA';
								ELSEIF(EstatusC ='I'  )THEN
									SET Var_EstatusDes :='INACTIVA';
										ELSEIF( EstatusC  ='C'  )THEN
											SET Var_EstatusDes :='CANCELADA';
					END IF;

					IF(EstatusC=EstatusActivo) THEN
							IF(SaldoDisp<Par_Monto) THEN
								SET Par_NumErr		:= 5;
								SET Par_ErrMen		:= CONCAT('Saldo Insuficiente.');
								SET Var_Control		:= 'cuentaAhoID' ;
								SET Var_Consecutivo := '0';
								LEAVE ManejoErrores;
							END IF;
					END IF;

					IF(EstatusC<>EstatusActivo) THEN
						SET Par_NumErr		:= 6;
						SET Par_ErrMen		:= CONCAT('No se Puede hacer movimientos en esta Cuenta. Estatus ',Var_EstatusDes, ' Cuenta: ', Par_CuentaAhoID);
						SET Var_Control		:= 'cuentaAhoID' ;
						SET Var_Consecutivo := '0';
						LEAVE ManejoErrores;
					END IF;

                    -- VERIFICAMOS QUE NO SEAN NULL LOS PORCENTAJES  QUE SE APLICARAN A EL CREDITO Y AL CREDITO CONTINGENTE
					SET Par_PorcentajeCast     := IFNULL(Par_PorcentajeCast,Entero_Cero);
					SET Par_PorcentajeCastCont := IFNULL(Par_PorcentajeCastCont,Entero_Cero);

					IF(Par_PorcentajeCast != Entero_Cero) THEN
						IF(Par_PorcentajeCastCont != Entero_Cero) THEN
							SET Var_SaldoRecupera   := IFNULL(ROUND(((Par_Monto * Par_PorcentajeCast)/100),2),Entero_Cero);
							SET Var_SaldoRecuperaCont := IFNULL(ROUND((Par_Monto - Var_SaldoRecupera),2),Entero_Cero);
						ELSE
							SET Var_SaldoRecupera   :=  IFNULL(Par_Monto,Entero_Cero);
						END IF;

					ELSE
						IF(Par_PorcentajeCastCont != Entero_Cero) THEN
							SET Var_SaldoRecuperaCont := IFNULL(Par_Monto,Entero_Cero);
						ELSE
							SET Par_NumErr  := 7;
							SET Par_ErrMen  :='No Se Pudo Determinar el Monto por Aplicar al Credito';
							SET Var_Control :='montoRecuperar';
							LEAVE ManejoErrores;
						END IF;

					END IF;
                      IF (Var_SaldoRecupera > Var_PorRecuperar)THEN
						SET Par_NumErr  := 8;
						SET Par_ErrMen  :='El Monto del Deposito Excede el Total del Monto por Recuperar';
						SET Var_Control :='montoRecuperar';
						LEAVE ManejoErrores;
					END IF;

                    IF(Par_PorcentajeCastCont > Entero_Cero) THEN
						 IF(IFNULL(VarCreditoCont,Entero_Cero) != Entero_Cero) THEN
								-- DATOS GENERALES DEL CREDITO CONTINGENTE CASTIGADO
								SELECT   SaldoCapital,      SaldoInteres,     SaldoMoratorio,     SaldoAccesorios
									INTO Var_SaldoCapitalCont,  Var_SaldoInteresCont, Var_SaldoMoratorioCont, Var_SaldoAccesoriosCont
								FROM CRECASTIGOSCONT
								WHERE CreditoID = Par_CreditoID;

								 -- Inicializaciones
								SET Var_SaldoCapitalCont    := IFNULL(Var_SaldoCapitalCont, Decimal_Cero );
								SET Var_SaldoInteresCont    := IFNULL(Var_SaldoInteresCont, Decimal_Cero );
								SET Var_SaldoMoratorioCont  := IFNULL(Var_SaldoMoratorioCont, Decimal_Cero );
								SET Var_SaldoAccesoriosCont := IFNULL(Var_SaldoAccesoriosCont, Decimal_Cero );

								SET Var_PorRecuperarCont :=  ROUND(Var_SaldoCapitalCont* (1+Var_TasaIVA),2) +
															 ROUND(Var_SaldoInteresCont * (1+Var_TasaIVA),2) +
															 ROUND(Var_SaldoMoratorioCont * (1+Var_TasaIVA),2) +
															 ROUND(Var_SaldoAccesoriosCont * (1+Var_TasaIVA),2);

								IF (Var_SaldoRecuperaCont > Var_PorRecuperarCont)THEN
									SET Par_NumErr  := 9;
									SET Par_ErrMen  :='El Monto del Deposito Excede el Total del Monto por Recuperar';
									SET Var_Control :='montoRecuperar';
									LEAVE ManejoErrores;
								END IF;
                         ELSE
								SET Par_NumErr  := 10;
								SET Par_ErrMen  :='El Credito No Tiene Un Credito Contingente';
								SET Var_Control :='creditoID';
								LEAVE ManejoErrores;
						 END IF;
                    END IF;

			END IF;

        END IF;

    END IF;

	SET Var_SaldoRecupera := IFNULL(Var_SaldoRecupera,Decimal_Cero);
    SET Var_SaldoRecuperaCont := IFNULL(Var_SaldoRecuperaCont,Decimal_Cero);

    CALL RECCREAGROCASTPRO(  Par_CreditoID,      Var_FechaAplicacion, Var_SaldoRecupera,    Var_MonedaID,        Var_ProductoCred,
							 Var_ClasifCre,      Var_SubClasifID,     Var_SucursalCliente,  Par_DescripcionMov,  Par_PolizaID,
							 Salida_NO,          Par_NumErr,          Par_ErrMen,           Var_Capital,         Var_Interes,
							 Var_Moratorios,	 Var_Comision, 		  Var_IVA,
                             Par_EmpresaID,      Aud_Usuario,   	  Aud_FechaActual,   	 Aud_DireccionIP,     Aud_ProgramaID,
                             Aud_Sucursal,       Aud_NumTransaccion);

    IF(Par_NumErr != Entero_Cero)THEN
                SET Var_Control     := 'creditoID';
                LEAVE ManejoErrores;
    END IF;

    IF(IFNULL(VarCreditoCont,Entero_Cero) != Entero_Cero) THEN


		CALL RECCREAGROCASTCONTPRO(  Par_CreditoID,      Var_FechaAplicacion, Var_SaldoRecuperaCont,    Var_MonedaID,        Var_ProductoCred,
									 Var_ClasifCre,      Var_SubClasifID,     Var_SucursalCliente,	    Par_DescripcionMov,  Par_PolizaID,
                                     Salida_NO,			 Par_NumErr,          Par_ErrMen,  				Var_CapitalCont,     Var_InteresCont,
                                     Var_MoratoriosCont, Var_ComisionCont, 	  Var_IVACont,
                                     Par_EmpresaID,      Aud_Usuario,         Aud_FechaActual, 			Aud_DireccionIP,   Aud_ProgramaID,
                                     Aud_Sucursal,       Aud_NumTransaccion);

		IF(Par_NumErr != Entero_Cero)THEN
					SET Var_Control     := 'creditoID';
					LEAVE ManejoErrores;
		END IF;

    END IF;

    CALL CARGOABONOCUENTAPRO(Par_CuentaAhoID,       Par_ClienteID,          Aud_NumTransaccion,                 Var_FechaAplicacion,        Var_FechaAplicacion,
							Nat_Cargo,              Par_Monto,              Descripcion	,						Par_CreditoID,             	Mov_RecCartCast,
                            Var_MonedaID,           Var_SucursalCliente,    AltaEncPolisaNO,                    Entero_Cero,                Par_PolizaID,
							AltaPolizaSI,           Mov_Pasivo, 			Nat_Cargo,                          Var_Consecutivo,            Salida_NO,
							Par_NumErr,             Par_ErrMen,             Par_EmpresaID,                      Aud_Usuario,                Aud_FechaActual,
							Aud_DireccionIP,        Aud_ProgramaID,         Aud_Sucursal,                       Aud_NumTransaccion);

    IF(Par_NumErr != Entero_Cero)THEN
                SET Var_Control     := 'creditoID';
                LEAVE ManejoErrores;
    END IF;

    SET CON_Ticket =IFNULL((SELECT MAX(ReimpresionID) FROM REIMPRESIONTICKET),Entero_Cero);
    SET CON_Ticket =  CON_Ticket + 1;

	SELECT   SaldoCapital,      SaldoInteres,     SaldoMoratorio,     SaldoAccesorios
		INTO Var_SaldoCapitalCont,  Var_SaldoInteresCont, Var_SaldoMoratorioCont, Var_SaldoAccesoriosCont
	FROM CRECASTIGOSCONT
	WHERE CreditoID = Par_CreditoID;

	 -- SE VUELVE A CALCULAR EL ADEUDO PARA PODER IMPRIMR EL TICKET
	SET Var_SaldoCapitalCont    := IFNULL(Var_SaldoCapitalCont, Decimal_Cero );
	SET Var_SaldoInteresCont    := IFNULL(Var_SaldoInteresCont, Decimal_Cero );
	SET Var_SaldoMoratorioCont  := IFNULL(Var_SaldoMoratorioCont, Decimal_Cero );
	SET Var_SaldoAccesoriosCont := IFNULL(Var_SaldoAccesoriosCont, Decimal_Cero );

	SET Var_PorRecuperarCont :=  ROUND(Var_SaldoCapitalCont* (1+Var_TasaIVA),2) +
								 ROUND(Var_SaldoInteresCont * (1+Var_TasaIVA),2) +
								 ROUND(Var_SaldoMoratorioCont * (1+Var_TasaIVA),2) +
								 ROUND(Var_SaldoAccesoriosCont * (1+Var_TasaIVA),2);

    SELECT   SaldoCapital,      SaldoInteres,     SaldoMoratorio,     SaldoAccesorios
        INTO Var_SaldoCapital,  Var_SaldoInteres, Var_SaldoMoratorio, Var_SaldoAccesorios
    FROM CRECASTIGOS
    WHERE CreditoID = Par_CreditoID;

    SET Var_SaldoCapital    := IFNULL(Var_SaldoCapital, Decimal_Cero );
    SET Var_SaldoInteres    := IFNULL(Var_SaldoInteres, Decimal_Cero );
    SET Var_SaldoMoratorio  := IFNULL(Var_SaldoMoratorio, Decimal_Cero );
    SET Var_SaldoAccesorios := IFNULL(Var_SaldoAccesorios, Decimal_Cero );

	SET Var_PorRecuperar :=  ROUND(Var_SaldoCapital * (1+Var_TasaIVA),2) +
                             ROUND(Var_SaldoInteres * (1+Var_TasaIVA),2) +
                             ROUND(Var_SaldoMoratorio * (1+Var_TasaIVA),2) +
                             ROUND(Var_SaldoAccesorios * (1+Var_TasaIVA),2);

       -- TotalesCobrados
    SET Var_TotalCapital        = IFNULL(Var_Capital,Entero_Cero) + IFNULL(Var_CapitalCont,Entero_Cero);			-- CAPITAL PAGADO
    SET Var_TotalInteres        = IFNULL(Var_Interes,Entero_Cero) + IFNULL(Var_InteresCont,Entero_Cero);			-- INTERES PAGADO
    SET Var_TotalMoratorios     = IFNULL(Var_Moratorios,Entero_Cero) + IFNULL(Var_MoratoriosCont,Entero_Cero);		-- MORATORIO PAGADO
    SET Var_TotalComision       = IFNULL(Var_Comision,Entero_Cero) + IFNULL(Var_ComisionCont,Entero_Cero);			-- COMISION PAGADA
    SET Var_TotalIVA            = IFNULL(Var_IVA,Entero_Cero) + IFNULL(Var_IVACont,Entero_Cero);  					-- IVA PAGADO

	SET Var_TotalAdeudo := (IFNULL(Var_PorRecuperar,Entero_Cero)) + (IFNULL(Var_PorRecuperarCont,Entero_Cero));

    INSERT INTO REIMPRESIONTICKET
	(ReimpresionID,		TransaccionID,		SucursalID,	   	 		UsuarioID, 	 			Fecha,
	 Efectivo, 		  	NombrePersona,      CreditoID,		 		MontoProximoPago,
     Capital, 			Interes,		 	Moratorios, 	 		Comision,				IVA,
	 EmpresaID,			Usuario,			FechaActual,	 		DireccionIP,			ProgramaID,
	 Sucursal,			NumTransaccion)
	VALUES
	(CON_Ticket,		Aud_NumTransaccion,	Aud_Sucursal,		 	Aud_Usuario ,			Var_FechaAplicacion,
	Par_Monto,			Par_ClienteID,		Par_CreditoID,		 	Var_TotalAdeudo,
	Var_TotalCapital,	Var_TotalInteres,	Var_TotalMoratorios, 	Var_TotalComision, 		Var_TotalIVA,
	Par_EmpresaID,		Aud_Usuario,		Aud_FechaActual,		Aud_DireccionIP,		Aud_ProgramaID,
    Aud_Sucursal,		Aud_NumTransaccion);


    SET Par_NumErr  := 0;
    SET Par_ErrMen  := 'Operacion Realizada Correctamente.';
    SET Var_Control := 'creditoID';


END ManejoErrores;

 IF (Par_Salida = Salida_SI) THEN
    SELECT  CONVERT(Par_NumErr, CHAR(3)) AS NumErr,
            Par_ErrMen AS ErrMen,
            Var_Control AS control,
            Par_PolizaID AS consecutivo;
END IF;


END TerminaStore$$