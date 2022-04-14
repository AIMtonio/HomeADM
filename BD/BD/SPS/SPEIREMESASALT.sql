-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- SPEIREMESASALT
DELIMITER ;
DROP PROCEDURE IF EXISTS `SPEIREMESASALT`;
DELIMITER $$


CREATE PROCEDURE `SPEIREMESASALT`(
-- =====================================================================================
-- ------- STORE PARA DAR DE ALTA UNA REMESA SPEI ---------
-- =====================================================================================
	Par_ClaveRastreo	   VARCHAR(30),
	Par_TipoPago		   INT(2),
	Par_TipoCuentaOrd	   INT(2),
	Par_CuentaOrd		   VARCHAR(20),
	Par_NombreOrd		   VARCHAR(40),

	Par_RFCOrd	           VARCHAR(18),
	Par_TipoOperacion	   INT(2),
	Par_MontoTransferir	   DECIMAL(16,2),
	Par_IVA				   DECIMAL(16,2),
	Par_ComisionTrans	   DECIMAL(16,2),

	Par_IVAComision		   DECIMAL(16,2),
	Par_InstiRemitente	   INT(5),
	Par_InstiReceptora	   INT(5),
	Par_CuentaBeneficiario VARCHAR(20),
	Par_NombreBeneficiario VARCHAR(40),

	Par_RFCBeneficiario	   VARCHAR(18),
	Par_TipoCuentaBen	   INT(2),
	Par_ConceptoPago	   VARCHAR(40),
	Par_CuentaBenefiDos    VARCHAR(20),
	Par_NombreBenefiDos    VARCHAR(40),

	Par_RFCBenefiDos	   VARCHAR(18),
	Par_TipoCuentaBenDos   INT(2),
	Par_ConceptoPagoDos    VARCHAR(40),
	Par_ReferenciaCobranza VARCHAR(40),
	Par_ReferenciaNum      INT(7),

	Par_Prioridad    	   INT(1),
	Par_EstatusRem         INT(3),
	Par_UsuarioEnvio       VARCHAR(30),
	Par_AreaEmiteID	       INT(2),
	Par_FechaRecepcion     DATETIME,

	Par_CausaDevol         INT(2),
	Par_Topologia          CHAR(1),
	Par_Folio              BIGINT(20),
	Par_FolioPaquete       BIGINT(20),
	Par_FolioServidor      BIGINT(20),

	Par_Firma              VARCHAR(250),
	Par_SpeiDetSolDesID		BIGINT(20),
	Par_SpeiSolDesID		BIGINT(20),
	Par_CuentaAhoID			BIGINT(20),

	Par_Salida			   CHAR(1),
	INOUT Par_NumErr	   INT(11),
	INOUT Par_ErrMen	   VARCHAR(400),

	/* Parámetros de Auditoria */
	Par_EmpresaID		   INT(11),
	Aud_Usuario			   INT(11),
	Aud_FechaActual		   DATETIME,
	Aud_DireccionIP		   VARCHAR(20),

	Aud_ProgramaID		   VARCHAR(50),
	Aud_Sucursal		   INT(11),
	Aud_NumTransaccion	   BIGINT(20)
)

TerminaStore: BEGIN

-- Declaracion de Constantes
DECLARE	Cadena_Vacia	CHAR(1);
DECLARE	Entero_Cero		INT;
DECLARE	Decimal_Cero	DECIMAL(18,2);
DECLARE	Fecha_Vacia		DATE;
DECLARE Salida_SI 		CHAR(1);
DECLARE	Salida_NO		CHAR(1);
DECLARE Est_Pen         CHAR(1);
DECLARE Mon_Pesos       INT(11);
DECLARE tipoCtaClabe    INT(2);         -- Cuenta tipo CLABE
DECLARE tipoCtaTar      INT(2);         -- Cuenta tipo tarjeta debito
DECLARE tipoCtaTel      INT(2);         -- Cuenta tipo numero de telefonia movil
DECLARE LongitudCta     INT(18);        -- longitud de la cuenta del beneficiario
DECLARE LongClabe       INT(2);         -- Longitud de la CLABE
DECLARE LongTarjeta     INT(2);         -- Longitud de la tarjeta
DECLARE LongCel         INT(2);         -- Longitud del numero telefonico movil
DECLARE ImporteMaximo   DECIMAL(20,2);  -- Importe maximo para tranferir spei
DECLARE Est_Activo      CHAR(1);        -- Estatus activo
DECLARE	Tp_tt            INT(2);         -- tipo de pago tercero a tercero
DECLARE	Tp_ttv           INT(2);         -- tipo de pago tercero a tercero vostro
DECLARE	Tp_pp            INT(2);         -- tipo de pago participante a participante
DECLARE	Tp_nom           INT(2);         -- Tipo de pago nomina
DECLARE Tp_tv            INT(2);         -- tipo de pago de tercero a ventanilla
DECLARE Tp_tp            INT(2);         -- tipo de pago de tercero a participante
DECLARE Tp_pt            INT(2);         -- Tipo de pago de participante a tercero
DECLARE Tp_ptv           INT(2);         -- Tipo de pago de participante a tercero vostro
DECLARE Tp_ttfsw         INT(2);         -- tipo de pago de tercero a tercero fsw
DECLARE Tp_ttvfsw        INT(2);         -- tipo de pago de tercero a tercero vostro fsw
DECLARE Tp_ptfsw         INT(2);         -- tipo de pago de participante a tercero fsw
DECLARE Tp_ptvfsw        INT(2);         -- tipo de pago de participante a tercero vostro fsw
DECLARE Tp_Remesa		 INT(2);		 -- tipo de pago Remesa.
DECLARE Cta_Aho          CHAR(1);        -- tipo de cuenta ahorro
DECLARE Est_Bloqueada    CHAR(1);        -- Estado bloqueada
DECLARE Est_Cancelada    CHAR(1);        -- Estado calcelada

-- Declaracion de Variables
DECLARE Var_Control	    VARCHAR(200);   -- Variable de control
DECLARE Var_Consecutivo	BIGINT(20);     -- Variable consecutivo
DECLARE Var_FechaAut    DATE;           -- fecha autorizacion
DECLARE Var_Estatus     CHAR(1);        -- estatus safi
DECLARE Var_TotCta      DECIMAL(18,2);  -- total cargo cuenta
DECLARE Var_UsuarioAut  VARCHAR(30);    -- Usuario que autoriza
DECLARE Var_FolioSpei   BIGINT(20);     -- Folio del spei
DECLARE Var_CuentaAho   BIGINT(12);        -- cuenta del cliente
DECLARE Var_EstatusPago CHAR(1);        -- estatus de tipo de pago
DECLARE Var_EstCli		  CHAR(1);	    -- Estatus del CLiente
DECLARE Var_TipoCuenta    CHAR(1);      -- Tipo Cuenta


-- Asignacion de Constantes
SET	Cadena_Vacia	:= '';             -- Cadena Vacia
SET	Fecha_Vacia		:= '1900-01-01 00:00:00';   -- Fecha Vacia
SET	Entero_Cero		:= 0;              -- Entero Cero
SET	Decimal_Cero	:= 0.0;            -- Decimal cero
SET Salida_SI 	   	:= 'S';            -- Salida SI
SET	Salida_NO		:= 'N';            -- Salida NO
SET	Par_NumErr		:= 0;              -- Parametro numero de error
SET	Par_ErrMen		:= '';             -- Parametro Mensaje de error
SET Mon_Pesos		:= 1;			   -- Moneda Pesos
SET Est_Bloqueada   := 'B';            -- Estatus bloqueado
SET Est_Cancelada   := 'C';            -- Estatus cancelada
SET Est_Activo		:= 'A';			   -- Estatus Activo
SET ImporteMaximo   := 999999999999.99;-- importe maximo para las transferencias spei
SET	Tp_tt           := 1;              -- tipo de pago tercero a tercero
SET Tp_tv           := 2;              -- tipo de pago de tercero a ventanilla
SET	Tp_ttv          := 3;              -- tipo de pago tercero a tercero vostro
SET Tp_tp           := 4;              -- tipo de pago de tercero a participante
SET Tp_pt           := 5;              -- Tipo de pago de participante a tercero
SET Tp_ptv          := 6;              -- Tipo de pago de participante a tercero vostro
SET	Tp_pp           := 7;              -- tipo de pago participante a participante
SET Tp_ttfsw        := 8;              -- tipo de pago de tercero a tercero fsw
SET Tp_ttvfsw       := 9;              -- tipo de pago de tercero a tercero vostro fsw
SET Tp_ptfsw        := 10;             -- tipo de pago de participante a tercero fsw
SET Tp_ptvfsw       := 11;             -- tipo de pago de participante a tercero vostro fsw
SET	Tp_nom          := 12;             -- Tipo de pago nomina
SET Tp_Remesa		:= 15;			   -- Tipo de pago Remesa.
SET Cta_Aho         := 'A';            -- tipo de cuenta ahorro
SET Mon_Pesos       := 1;              -- moneda pesos
SET Est_Pen         := 'P';            -- Estatus pendiente
SET LongClabe       := 18;             -- Longitud de la CLABE
SET LongTarjeta     := 16;             -- Longitud de la tarjeta
SET LongCel         := 10;             -- Longitud del numero telefonico movil
SET ImporteMaximo   := 999999999999.99;-- importe maximo para las transferencias spei
SET tipoCtaClabe    := 40;             -- tipo de cuenta clabe
SET tipoCtaTar      := 3;              -- tipo de cuenta tarjeta
SET tipoCtaTel      := 10;             -- Tipo de cuenta numero de cel.

ManejoErrores:BEGIN
	DECLARE EXIT HANDLER FOR SQLEXCEPTION
		BEGIN
			GET DIAGNOSTICS condition 1
			@Var_SQLState = RETURNED_SQLSTATE, @Var_SQLMessage = MESSAGE_TEXT;
			SET Par_NumErr = 999;
			SET Par_ErrMen =  LEFT(CONCAT('El SAFI ha tenido un problema al concretar la operacion. Disculpe las molestias que ',
				 'esto le ocasiona. Ref: SP-SPEIREMEASASALT','[',@Var_SQLState,'-' , @Var_SQLMessage,']'), 400);
			SET Var_Control = 'sqlException';
		END;

-- --------------Validacionessss ---------------------------

IF NOT EXISTS (SELECT TipoPagoID
	FROM TIPOSPAGOSPEI
	WHERE TipoPagoID = Par_TipoPago)THEN
		SET Par_NumErr := 001;
		SET Par_ErrMen :='Tipo de pago No existe';
		SET Var_Control:=  'tipoPago' ;
		LEAVE ManejoErrores;
END IF;

-- validacion que el tipo de pago este activo

SET Var_EstatusPago :=(SELECT Estatus FROM TIPOSPAGOSPEI WHERE TipoPagoID = Par_TipoPago);

IF (Var_EstatusPago != Est_Activo)THEN
	SET Par_NumErr := 002;
	SET Par_ErrMen :='Tipo de pago inactivo';
	SET Var_Control:=  'EstatusPago' ;
	LEAVE ManejoErrores;
END IF;


IF NOT EXISTS (SELECT InstitucionID
   FROM INSTITUCIONESSPEI
   WHERE InstitucionID = Par_InstiRemitente)THEN
	SET Par_NumErr	:= 003;
	SET Par_ErrMen	:='La institucion remitente no existe';
	SET Var_Control	:=  'InstiRemitente' ;
	LEAVE ManejoErrores;
END IF;

IF NOT EXISTS (SELECT InstitucionID
   FROM INSTITUCIONESSPEI
   WHERE InstitucionID = Par_InstiReceptora)THEN
	SET Par_NumErr	:= 004;
	SET Par_ErrMen	:='La institucion receptora no existe';
	SET Var_Control	:=  'InstiReceptora' ;
	LEAVE ManejoErrores;
END IF;

IF NOT EXISTS (SELECT AreaEmiteID
   FROM AREASEMITESPEI
   WHERE AreaEmiteID = Par_AreaEmiteID)THEN
	SET Par_NumErr	:= 005;
	SET Par_ErrMen	:='El area que emite no existe';
	SET Var_Control	:=  'AreaEmite' ;
	LEAVE ManejoErrores;
END IF;


	IF (Par_TipoPago != Entero_Cero) THEN

		IF(Par_TipoPago = Tp_tt || Par_TipoPago = Tp_ttfsw || Par_TipoPago = Tp_ptfsw || Par_TipoPago = Tp_nom || Par_TipoPago =Tp_ttv) THEN

			IF (Par_TipoCuentaOrd = tipoCtaClabe) THEN

				IF EXISTS(SELECT CuentaAhoID FROM CUENTASAHO WHERE Clabe = Par_CuentaOrd) THEN
					SET Var_TipoCuenta := Cta_Aho;
					SELECT CuentaAhoID INTO Var_CuentaAho
					FROM CUENTASAHO
					WHERE Clabe = Par_CuentaOrd;
				ELSE
					SET Par_NumErr := 007;
					SET Par_ErrMen :=CONCAT('Cuenta inexistente: ',Par_CuentaOrd );
					SET Var_Control:= 'cuentaOrdenante';
					LEAVE ManejoErrores;
				END IF;
			END IF;

			IF (Par_TipoCuentaOrd = tipoCtaTar) THEN

				IF EXISTS(SELECT CuentaAhoID
					FROM TARJETADEBITO
					WHERE TarjetaDebID = Par_CuentaOrd) THEN
					SET Var_TipoCuenta := Cta_Aho;
					SELECT CuentaAhoID INTO Var_CuentaAho
					FROM TARJETADEBITO
					WHERE TarjetaDebitoID = Par_CuentaOrd;
				ELSE
					SET Par_NumErr := 008;
					SET Par_ErrMen :=CONCAT('Cuenta inexistente: ',Par_CuentaOrd );
					SET Var_Control:= 'cuentaBeneficiario';
					LEAVE ManejoErrores;
				END IF;
			END IF;
		END IF;

		IF (Var_TipoCuenta = Cta_Aho) THEN

			-- CAUSA DEVOLUCION 2 : CUENTA BLOQUEADA
			SELECT CuentaAhoID, Estatus
			INTO Var_CuentaAho, Var_Estatus
			FROM CUENTASAHO
			WHERE	CuentaAhoID	= Var_CuentaAho;

			IF(Var_CuentaAho != Entero_Cero AND Var_Estatus = Est_Bloqueada) THEN
				SET Par_NumErr := 009;
				SET Par_ErrMen :=CONCAT('Cuenta bloqueada: ',Par_CuentaOrd );
				SET Var_Control:= 'CuentaOrdenante';
				LEAVE ManejoErrores;
			END IF;


			-- CAUSA DEVOLUCION 3 : CUENTA CANCELADA

			SELECT Cue.CuentaAhoID, Cue.Estatus, Cli.Estatus
				INTO Var_CuentaAho, Var_Estatus, Var_EstCli
			FROM CUENTASAHO Cue INNER JOIN CLIENTES Cli
				ON Cue.ClienteID	= Cli.CLienteID
			WHERE	Cue.CuentaAhoID	= Var_CuentaAho;


			IF((Var_CuentaAho != Entero_Cero AND Var_Estatus = Est_Cancelada) OR ( Var_EstCli != Est_Activo)) THEN
				SET Par_NumErr := 010;
				SET Par_ErrMen :=CONCAT('Cuenta Ordenante Cancelada: ',Par_CuentaOrd );
				SET Var_Control:= 'cuentaOrdenante';
				LEAVE ManejoErrores;
			END IF;

			-- QUE LA CUENTA EXISTA EN LA TABLA CUENTASAHO

			IF NOT EXISTS (SELECT CuentaAhoID
			FROM CUENTASAHO
			WHERE CuentaAhoID = Var_CuentaAho)THEN
				SET Par_NumErr := 011;
				SET Par_ErrMen :=CONCAT('La cuenta ',Var_CuentaAho, 'no Existe');
				SET Var_Control:=  'cuentaAhoID' ;
				LEAVE ManejoErrores;
			END IF;

			-- QUE EL CLIENTE EN LA TABLA CLIENTES

			IF NOT EXISTS (SELECT CL.ClienteID
			FROM CUENTASAHO CA INNER JOIN CLIENTES CL ON CA.ClienteID = CL.ClienteID
			WHERE CuentaAhoID = Var_CuentaAho)THEN
				SET Par_NumErr := 012;
				SET Par_ErrMen :='El cliente no Existe';
				SET Var_Control:= 'cuentaAhoID' ;
				LEAVE ManejoErrores;
			END IF;

			-- LLAMADA A LA FUNCION DE VALIDACION DE CARACTERES SPEI

			-- VALIDACIONES PARA EL ORDENANTE

			SET Par_NumErr:= FNVALIDACARACSPEI(Par_NombreOrd);

			IF (Par_NumErr = 100)THEN
				SET Par_NumErr = 013;
				SET Par_ErrMen ='Caracter invalido';
				SET Var_Control=  'NombreOrd' ;
				LEAVE ManejoErrores;
			END IF;

			SET Par_NumErr:= FNVALIDACARACSPEI(Par_RFCOrd);

			IF ( Par_NumErr= 100)THEN
				SET Par_NumErr = 013;
				SET Par_ErrMen ='Caracter invalido';
				SET Var_Control=  'RFCOrd' ;
				LEAVE ManejoErrores;
			END IF;

			-- VALIDACIONES PARA ELBENEFICIARIO UNO

			SET Par_NumErr:= FNVALIDACARACSPEI(Par_NombreBeneficiario);

			IF (Par_NumErr = 100)THEN
				SET Par_NumErr = 013;
				SET Par_ErrMen ='Caracter invalido';
				SET Var_Control=  'NombreBeneficiario' ;
				LEAVE ManejoErrores;
			END IF;

			SET  Par_NumErr:= FNVALIDACARACSPEI(Par_RFCBeneficiario);

			IF (Par_NumErr = 100)THEN
				SET Par_NumErr = 013;
				SET Par_ErrMen ='Caracter invalido';
				SET Var_Control=  'RFCBeneficiario' ;
				LEAVE ManejoErrores;
			END IF;

			SET Par_NumErr:= FNVALIDACARACSPEI(Par_ConceptoPago);

			IF (Par_NumErr = 100)THEN
				SET Par_NumErr = 013;
				SET Par_ErrMen ='Caracter invalido';
				SET Var_Control=  'conceptoPago' ;
				LEAVE ManejoErrores;
			END IF;

			-- VALIDACIONES DE COMISIONES E IVA'S

			IF ISNULL(Par_IVA) THEN
				SET Par_NumErr := 014;
				SET Par_ErrMen :='El IVA por pagar esta vacio.';
				SET Var_Control:= 'IVA' ;
				LEAVE ManejoErrores;
			END IF;

			IF (Par_IVA != Decimal_Cero)THEN
				IF(Par_IVA < Decimal_Cero)THEN
					SET Par_NumErr := 015;
					SET Par_ErrMen :='El IVA por pagar no puede ser negativo.';
					SET Var_Control:=  'ivaporpagar' ;
					LEAVE ManejoErrores;
				END IF;
			END IF;

			-- Si el IVA por pagar viene nulo se seteo con Decimal cero
			SET Par_IVA := IFNULL(Par_IVA, Decimal_Cero);

			-- Si la comision transferencia viene nulo se seteo con Decimal cero
			SET Par_ComisionTrans := IFNULL(Par_ComisionTrans, Decimal_Cero);

			IF ISNULL(Par_ComisionTrans) THEN
				SET Par_NumErr := 016;
				SET Par_ErrMen :='La Comision por Transferencia esta Vacia.';
				SET Var_Control:= 'comisionTrans' ;
				LEAVE ManejoErrores;
			END IF;

			SET Par_IVAComision := IFNULL(Par_IVAComision, Decimal_Cero);

			IF ISNULL(Par_IVAComision)THEN
				SET Par_NumErr := 017;
				SET Par_ErrMen :='El IVA por Comision esta Vacio.';
				SET Var_Control:= 'IVAComision' ;
				LEAVE ManejoErrores;
			END IF;



			-- validacion tipo de cuenta y cuenta del beneficiario uno
			IF((Par_TipoCuentaBen !=Entero_Cero AND LENGTH(Par_CuentaBeneficiario) !=Entero_Cero))THEN
			-- SI LA CUENTA ES CUENTA CLABE
				IF(Par_TipoCuentaBen = tipoCtaClabe) THEN
					SET LongitudCta := LENGTH(LTRIM(RTRIM(CONVERT(Par_CuentaBeneficiario,CHAR(18)))));
					IF(LongitudCta != LongClabe) THEN
								SET Par_NumErr := 018;
								SET Par_ErrMen := CONCAT('El numero de caracteres no coincide para la CLABE. ',Par_CuentaBeneficiario);
								SET Var_Control:=  'cuentaBeneficiario' ;
								LEAVE ManejoErrores;
					END IF;
				END IF;

				-- SI LA CUENTA ES NUMERO DE TARJETA
				IF(Par_TipoCuentaBen = tipoCtaTar) THEN
					SET LongitudCta := LENGTH(LTRIM(RTRIM(CONVERT(Par_CuentaBeneficiario,CHAR(16)))));
					IF(LongitudCta != LongTarjeta) THEN
						SET Par_NumErr := 019;
						SET Par_ErrMen :='El numero de caracteres no coincide para el numero de Tarjeta.';
						SET Var_Control:=  'cuentaBeneficiario' ;
						LEAVE ManejoErrores;
					END IF;
				END IF;

				-- SI LA CUENTA ES NUMERO DE TELEFONO MOVIL
				IF(Par_TipoCuentaBen = tipoCtaTel) THEN
					SET LongitudCta := LENGTH(LTRIM(RTRIM(CONVERT(Par_CuentaBeneficiario,CHAR(10)))));
					IF(LongitudCta != LongCel) THEN
						SET Par_NumErr := 020;
						SET Par_ErrMen :='El numero de caracteres no coincide con el numero de tel. movil.';
						SET Var_Control:=  'cuentaBeneficiario' ;
						LEAVE ManejoErrores;
					END IF;
				END IF;
			END IF;
		END IF;

		IF (Par_TipoPago = Tp_pt) THEN
			SELECT CuentaAhoID INTO Var_CuentaAho
					FROM CUENTASAHO
					WHERE Clabe = Par_CuentaOrd;
			SET Var_CuentaAho := IFNULL(Var_CuentaAho,Entero_Cero);
		END IF;
        -- fin del validacion tipos de pago que validan cuenta beneficiario

		-- VALIDACIONES DEL TIPO DE PAGO ES TERCERO A TERCERO

		IF (Par_TipoPago = Tp_tt)THEN

			IF(IFNULL(Par_NombreOrd,Cadena_Vacia)) = Cadena_Vacia THEN
				SET Par_NumErr := 026;
				SET Par_ErrMen := 'El Nombre del Ordenante esta Vacio.';
				SET Var_Control:=  'nombreOrd' ;
				LEAVE ManejoErrores;
			END IF;

			IF ISNULL(Par_TipoCuentaOrd)THEN
				SET Par_NumErr := 027;
				SET Par_ErrMen :='El Tipo de Cuenta Ordenante esta Vacio.';
				SET Var_Control:=  'tipoCuentaOrd' ;
				LEAVE ManejoErrores;
			END IF;

			-- QUE EL TIPO DE CUENTA DEL ORDENANTE EXISTA EN LA TABLA TIPOSCUENTASPEI

			IF NOT EXISTS (SELECT TipoCuentaID
				FROM TIPOSCUENTASPEI
				WHERE TipoCuentaID = Par_TipoCuentaOrd)THEN
				SET Par_NumErr := 028;
				SET Par_ErrMen :=CONCAT('El tipo de cuenta ',Par_TipoCuentaOrd, ' no Existe');
				SET Var_Control:=  'tipoCuentaOrd' ;
				LEAVE ManejoErrores;
			END IF;

			IF (IFNULL(Par_CuentaOrd, Cadena_Vacia)) = Cadena_Vacia THEN
				SET Par_NumErr := 029;
				SET Par_ErrMen :='La Cuenta Ordenante esta Vacio.';
				SET Var_Control:=  'cuentaOrd' ;
				LEAVE ManejoErrores;
			END IF;

			IF ISNULL(Par_RFCOrd)THEN
				SET Par_NumErr := 030;
				SET Par_ErrMen := 'El RFC del Ordenante esta Vacio.';
				SET Var_Control:=  'RFCOrd' ;
				LEAVE ManejoErrores;
			END IF;

			IF(IFNULL(Par_NombreBeneficiario,Cadena_Vacia)) = Cadena_Vacia THEN
				SET Par_NumErr := 031;
				SET Par_ErrMen := 'El Nombre del Benefeciario esta Vacio.';
				SET Var_Control:=  'nombreBeneficiario' ;
				LEAVE ManejoErrores;
			END IF;


			IF(IFNULL(Par_CuentaBeneficiario,Entero_Cero)) = Entero_Cero THEN
				SET Par_NumErr := 032;
				SET Par_ErrMen :='La Cuenta del Beneficiario esta Vacia.';
				SET Var_Control:=  'cuentaBeneficiario' ;
				LEAVE ManejoErrores;
			END IF;

			IF (IFNULL(Par_TipoCuentaBen,Entero_Cero)) = Entero_Cero THEN
				SET Par_NumErr := 033;
				SET Par_ErrMen := 'El Tipo de Cuenta del Beneficiario esta Vacio.';
				SET Var_Control:=  'tipoCuentaBen' ;
				LEAVE ManejoErrores;
			END IF;


			-- SI EL TIPO DE CUENTA EXISTE EN LA TABLA TIPOSCUENTASPEI
			IF NOT EXISTS (SELECT TipoCuentaID
				FROM TIPOSCUENTASPEI
				WHERE TipoCuentaID = Par_TipoCuentaBen) THEN
				SET Par_NumErr := 034;
				SET Par_ErrMen :=CONCAT('El tipo de cuenta ',Par_TipoCuentaBen, ' del beneficiario no Existe');
				SET Var_Control:=  'tipoCuentBen' ;
				LEAVE ManejoErrores;
			END IF;

			-- validacion tipo de cuenta y cuenta del beneficiario uno
			IF((Par_TipoCuentaBen !=Entero_Cero AND LENGTH(Par_CuentaBeneficiario) !=Entero_Cero)) THEN
			-- SI LA CUENTA ES CUENTA CLABE
				IF(Par_TipoCuentaBen = tipoCtaClabe) THEN
					SET LongitudCta := LENGTH(LTRIM(RTRIM(CONVERT(Par_CuentaBeneficiario,CHAR(18)))));
					IF(LongitudCta != LongClabe) THEN
						SET Par_NumErr := 035;
						SET Par_ErrMen := CONCAT('El numero de caracteres no coincide para la CLABE. ',Par_CuentaBeneficiario);
						SET Var_Control:=  'cuentaBeneficiario' ;
						LEAVE ManejoErrores;
					END IF;
				END IF;

				-- SI LA CUENTA ES NUMERO DE TARJETA
				IF(Par_TipoCuentaBen = tipoCtaTar) THEN
				SET LongitudCta := LENGTH(LTRIM(RTRIM(CONVERT(Par_CuentaBeneficiario,CHAR(16)))));
					IF(LongitudCta != LongTarjeta) THEN
						SET Par_NumErr := 036;
						SET Par_ErrMen :='El numero de caracteres no coincide para el numero de Tarjeta.';
						SET Var_Control:=  'cuentaBeneficiario' ;
						LEAVE ManejoErrores;
					END IF;
				END IF;

				-- SI LA CUENTA ES NUMERO DE TELEFONO MOVIL
				IF(Par_TipoCuentaBen = tipoCtaTel) THEN
				SET LongitudCta := LENGTH(LTRIM(RTRIM(CONVERT(Par_CuentaBeneficiario,CHAR(10)))));
					IF(LongitudCta != LongCel) THEN
						SET Par_NumErr := 037;
						SET Par_ErrMen :='El numero de caracteres no coincide con el numero de tel. movil.';
						SET Var_Control:=  'cuentaBeneficiario' ;
						LEAVE ManejoErrores;
					END IF;
				END IF;
			END IF;


			IF ISNULL(Par_RFCBeneficiario)THEN
				SET Par_NumErr := 038;
				SET Par_ErrMen := 'El RFC del Beneficiario esta Vacio.';
				SET Var_Control:=  'RFCBeneficiario' ;
				LEAVE ManejoErrores;
			END IF;

			IF ISNULL(Par_AreaEmiteID)THEN
				SET Par_NumErr := 039;
				SET Par_ErrMen := 'El Area que Emite esta Vacia.';
				SET Var_Control:=  'areaEmiteID' ;
				LEAVE ManejoErrores;
			END IF;

			IF ISNULL(Par_ConceptoPago)THEN
				SET Par_NumErr := 040;
				SET Par_ErrMen := 'El Concepto de Pago esta Vacio.';
				SET Var_Control:=  'conceptoPago' ;
				LEAVE ManejoErrores;
			END IF;


			IF(Par_MontoTransferir !=Decimal_Cero)THEN
				IF (Par_MontoTransferir > ImporteMaximo) THEN
					SET Par_NumErr := 041;
					SET Par_ErrMen :='El Monto a Transferir es mayor al monto permitido.';
					SET Var_Control:=  'montoTransferir' ;
					LEAVE ManejoErrores;
				END IF;

			ELSE
				SET Par_NumErr := 042;
				SET Par_ErrMen :='El Monto a Transferir esta Vacio.';
				SET Var_Control:=  'montoTransferir' ;
				LEAVE ManejoErrores;

				IF(Par_MontoTransferir < Decimal_Cero)THEN
					SET Par_NumErr := 043;
					SET Par_ErrMen :='El Monto a Transferir no puede ser negativo.';
					SET Var_Control:=  'montoTransferir' ;
					LEAVE ManejoErrores;
				END IF;
			END IF;


			-- Si la referencia cobranza viene nula se setea con cero
			SET Par_ReferenciaNum := IFNULL(Par_ReferenciaNum, Entero_Cero);

			-- Si la referencia cobranza viene nula se setea con un valor vacio
			SET Par_ReferenciaCobranza := IFNULL(Par_ReferenciaCobranza, Cadena_Vacia);

			IF ISNULL(Par_TipoPago)THEN
				SET Par_NumErr := 044;
				SET Par_ErrMen :='El Tipo de Pago esta Vacio.';
				SET Var_Control:=  'tipoPago' ;
				LEAVE ManejoErrores;
			END IF;

			-- PRIORIDAD DE ENVIO DE PARAMETROS SPEI
			SET Par_Prioridad := (SELECT Prioridad FROM PARAMETROSSPEI);

			IF(IFNULL(Par_InstiReceptora,Entero_Cero))= Entero_Cero THEN
				SET Par_NumErr := 045;
				SET Par_ErrMen :='La Institucion Receptora esta Vacia.';
				SET Var_Control:=  'instiReceptora' ;
				LEAVE ManejoErrores;
			END IF;


			-- VALIDACION QUE LA INSTITUCION REMITENTE Y RECEPTORA NO SEA LA MISMA
			IF (Par_InstiRemitente = Par_InstiReceptora) THEN
				SET Par_NumErr := 046;
				SET Par_ErrMen := 'Institucion remintente y receptora no pueden ser la misma';
				SET Var_Control:=  'InstiReceptora' ;
				LEAVE ManejoErrores;
			END IF;


			IF(IFNULL(Par_UsuarioEnvio,Cadena_Vacia)) = Cadena_Vacia THEN
				SET Par_NumErr := 047;
				SET Par_ErrMen := 'El Usuario que envio Operacion esta vacio.';
				SET Var_Control:=  'usuarioEnvio' ;
				LEAVE ManejoErrores;
			END IF;

			-- SI EL USUARIO EXISTE EN LA TABLA USUARIOS
			IF NOT EXISTS (SELECT UsuarioID
				FROM USUARIOS
				WHERE UsuarioID = Aud_Usuario)THEN
				SET Par_NumErr := 048;
				SET Par_ErrMen :=CONCAT('El usuario ',Par_UsuarioEnvio, ' no Existe');
				SET Var_Control:=  'usuarioEnvio' ;
				LEAVE ManejoErrores;
			END IF;

		END IF;-- fin del tipo de pago tercero a tercero


		IF(Par_TipoPago = Tp_tv || Par_TipoPago = Tp_tp || Par_TipoPago = Tp_ttfsw || Par_TipoPago = Tp_nom)THEN

			IF(IFNULL(Par_NombreOrd,Cadena_Vacia)) = Cadena_Vacia THEN
				SET Par_NumErr := 052;
				SET Par_ErrMen := 'Nombre del ordenante esta vacio.';
				SET Var_Control:=  'NombreOrd' ;
				LEAVE ManejoErrores;
			END IF;
	 	END IF;

		IF(Par_TipoPago = Tp_tv || Par_TipoPago = Tp_tp || Par_TipoPago = Tp_ttfsw || Par_TipoPago = Tp_nom)THEN

			IF (IFNULL(Par_TipoCuentaOrd,Entero_Cero)) = Entero_Cero THEN
				SET Par_NumErr := 053;
				SET Par_ErrMen :='Tipo de cuenta del ordenante esta vacia. ';
				SET Var_Control:=  'tipoCuentaOrd' ;
				LEAVE ManejoErrores;
			END IF;
		END IF;


		IF(Par_TipoPago = Tp_tv || Par_TipoPago = Tp_tp || Par_TipoPago = Tp_ttfsw || Par_TipoPago = Tp_nom)THEN

			IF (IFNULL(Par_CuentaOrd,Cadena_Vacia)) = Cadena_Vacia THEN
				SET Par_NumErr := 054;
				SET Par_ErrMen :='La cuenta del ordenante esta vacia';
				SET Var_Control:=  'cuentaOrd' ;
				LEAVE ManejoErrores;
			END IF;
		END IF;

		IF(Par_TipoPago = Tp_tv || Par_TipoPago = Tp_tp || Par_TipoPago = Tp_ttfsw || Par_TipoPago = Tp_nom)THEN

			IF ISNULL(Par_RFCOrd)THEN
				SET Par_NumErr := 055;
				SET Par_ErrMen := 'El RFC del ordenante esta vacio.';
				SET Var_Control:=  'RFCOrd' ;
				LEAVE ManejoErrores;
			END IF;
		END IF;

		IF(Par_TipoPago = Tp_tv || Par_TipoPago = Tp_pt || Par_TipoPago = Tp_ttfsw || Par_TipoPago = Tp_ptfsw || Par_TipoPago = Tp_nom)THEN

			IF(IFNULL(Par_NombreBeneficiario,Cadena_Vacia)) = Cadena_Vacia THEN
				SET Par_NumErr := 056;
				SET Par_ErrMen := 'El nombre del beneficiario esta vacio.';
				SET Var_Control:=  'nombreBeneficiario' ;
				LEAVE ManejoErrores;
			END IF;
		END IF;

		IF(Par_TipoPago = Tp_pt || Par_TipoPago = Tp_ttfsw || Par_TipoPago = Tp_ptfsw || Par_TipoPago = Tp_nom)THEN

			IF(IFNULL(Par_TipoCuentaBen,Entero_Cero)) = Entero_Cero THEN
				SET Par_NumErr := 057;
				SET Par_ErrMen := 'Tipo de cuenta del benefeciario esta vacio.';
				SET Var_Control:=  'tipoCuentaBen' ;
				LEAVE ManejoErrores;
			END IF;

			-- SI EL TIPO DE CUENTA NO EXISTE EN LA TABLA TIPOSCUENTASPEI
			IF NOT EXISTS (SELECT TipoCuentaID
				   FROM TIPOSCUENTASPEI
				   WHERE TipoCuentaID = Par_TipoCuentaBen)THEN
						 SET Par_NumErr = 058;
						 SET Par_ErrMen ='El tipo de cuenta del benefeciario no existe';
						 SET Var_Control=  'tipoCuentaBen' ;
						 LEAVE ManejoErrores;
			END IF;
		END IF;

		IF(Par_TipoPago = Tp_pt || Par_TipoPago = Tp_ttfsw || Par_TipoPago = Tp_ptfsw
			|| Par_TipoPago = Tp_nom)THEN

			IF(IFNULL(Par_CuentaBeneficiario,Entero_Cero)) = Entero_Cero THEN
				SET Par_NumErr := 059;
				SET Par_ErrMen :='La cuenta del beneficiario esta vacia.';
				SET Var_Control:=  'CuentaBeneficiario' ;
				LEAVE ManejoErrores;
			END IF;
		END IF;

		IF(Par_TipoPago = Tp_pt || Par_TipoPago = Tp_ttfsw || Par_TipoPago = Tp_ptfsw
			|| Par_TipoPago = Tp_nom)THEN

			IF ISNULL(Par_RFCBeneficiario)THEN
				SET Par_NumErr := 060;
				SET Par_ErrMen := 'RFC del beneficiario esta vacio';
				SET Var_Control:=  'RFCBeneficiario' ;
				LEAVE ManejoErrores;
			END IF;
		END IF;


		IF(Par_TipoPago = Tp_tv || Par_TipoPago = Tp_tp || Par_TipoPago = Tp_pt
	   		|| Par_TipoPago = Tp_pp || Par_TipoPago = Tp_ttfsw || Par_TipoPago = Tp_ptfsw || Par_TipoPago = Tp_nom)THEN


			IF ISNULL(Par_AreaEmiteID)THEN
				SET Par_NumErr := 061;
				SET Par_ErrMen := 'El area emite esta vacia';
				SET Var_Control:=  'areaEmite' ;
				LEAVE ManejoErrores;
			END IF;

			IF ISNULL(Par_ConceptoPago)THEN
				SET Par_NumErr := 062;
				SET Par_ErrMen := 'El concepto de pago esta vacio.';
				SET Var_Control:=  'conceptoPago' ;
				LEAVE ManejoErrores;
			END IF;


			IF (IFNULL(Par_MontoTransferir,Decimal_Cero)) = Decimal_Cero THEN
				SET Par_NumErr := 063;
				SET Par_ErrMen :='EL monto esta vacio.';
				SET Var_Control :=  'montoTransferir' ;
				LEAVE ManejoErrores;
			END IF;

			-- VALIDACION QUE EL MONTO A TRANSFERIR SEA MAYOR AL PERMITIDO POR SPEI
			IF (Par_MontoTransferir > ImporteMaximo) THEN
				SET Par_NumErr := 064;
				SET Par_ErrMen :='El monto es mayor al monto maximo';
				SET Var_Control :=  'montoTransferir' ;
				LEAVE ManejoErrores;
			END IF;

			IF ISNULL(Par_IVA) THEN
				SET Par_NumErr := 065;
				SET Par_ErrMen := 'El IVA esta vacio.';
				SET Var_Control:=  'IVA' ;
				LEAVE ManejoErrores;
			END IF;

			IF ISNULL(Par_ReferenciaNum) THEN
				SET Par_NumErr := 066;
				SET Par_ErrMen := 'La referencia numerica esta vacia.';
				SET Var_Control:=  'referenciaNum' ;
				LEAVE ManejoErrores;
			END IF;

			IF ISNULL(Par_TipoPago)THEN
					SET Par_NumErr := 067;
					SET Par_ErrMen :='EL tipo de pago esta vacio.';
					SET Var_Control:=  'tipoPago' ;
					LEAVE ManejoErrores;
			END IF;

			IF ISNULL(Par_Prioridad)THEN
				SET Par_NumErr := 068;
				SET Par_ErrMen := 'La prioridad esta vacia.';
				SET Var_Control:=  'prioridad' ;
				LEAVE ManejoErrores;
			END IF;


			IF(IFNULL(Par_ClaveRastreo,Cadena_Vacia)) = Cadena_Vacia THEN
				SET Par_NumErr := 069;
				SET Par_ErrMen := 'La clave de rastreo esta vacia.';
				SET Var_Control:=  'claveRastreo' ;
				LEAVE ManejoErrores;
			END IF;

			-- VALIDACION QUE LA INSTITUCION REMITENTE Y RECEPTORA NO SEA LA MISMA
			IF (Par_InstiRemitente = Par_InstiReceptora) THEN
				SET Par_NumErr := 070;
				SET Par_ErrMen := 'La institucion receptora y remitente no puede ser la misma';
				SET Var_Control:=  'InstReceptora' ;
				LEAVE ManejoErrores;
			END IF;

		END IF;

		IF(Par_TipoPago = Tp_ttfsw || Par_TipoPago = Tp_nom)THEN

			IF ISNULL(Par_ReferenciaCobranza) THEN
				SET Par_NumErr := 071;
				SET Par_ErrMen := 'La referencia de cobranza esta vacia.';
				SET Var_Control:=  'referenciaCobranza' ;
				LEAVE ManejoErrores;
			END IF;
		END IF;

		IF(Par_TipoPago = Tp_tv)THEN
			IF ISNULL(Par_ClavePago)THEN
				SET Par_NumErr := 072;
				SET Par_ErrMen :='La clave de pago esta vacia';
				SET Var_Control	:=  'clavePago' ;
				LEAVE ManejoErrores;
			END IF;
		END IF;

		-- si el tipo de pago es 4 entonces se valida que el tipo de operacion no sea vacio
		IF(Par_TipoPago = Tp_tp)THEN
			IF(IFNULL(Par_TipoOperacion,Entero_Cero))= Entero_Cero THEN
				SET Par_NumErr := 073;
				SET Par_ErrMen :='EL tipo de operacion esta vacio';
				SET Var_Control	:=  'tipoOperacion' ;
				LEAVE ManejoErrores;
			END IF;
		END IF;


		IF(Par_TipoPago = Tp_tp || Par_TipoPago = Tp_pp)THEN
			IF ISNULL(Par_TipoOperacion) THEN
				SET Par_NumErr := 074;
				SET Par_ErrMen :='El tipo de operacion esta vacio';
				SET Var_Control	:=  'tipoOPeracion' ;
				LEAVE ManejoErrores;
			END IF;
		END IF;

		-- CAUSA DEVOLUCION 16 : TIPO DE OPERACION ERRONEA

		-- SI EL TIPO DE OPERACION NO EXISTE EN LA TABLA TIPOSOPERACIONSPEI
		IF(Par_TipoOperacion !=Entero_Cero)THEN
			IF NOT EXISTS (SELECT TipoOperacionID
					FROM TIPOSOPERACIONSPEI
					WHERE TipoOperacionID = Par_TipoOperacion)THEN
						SET Par_NumErr := 075;
						SET Par_ErrMen :='Tipo de operacion no existe.';
						SET Var_Control:=  'tipoOperacion' ;
						LEAVE ManejoErrores;
			END IF;
		END IF;



		-- LLAMADA A LA FUNCION DE VALIDACION DE CARACTERES SPEI
		-- VALIDACIONES PARA EL ORDENANTE

		IF(Par_TipoPago = Tp_tv || Par_TipoPago = Tp_tp || Par_TipoPago = Tp_pt
		|| Par_TipoPago = Tp_pp || Par_TipoPago = Tp_ttfsw || Par_TipoPago = Tp_ptfsw || Par_TipoPago = Tp_nom)THEN

			SET Par_NumErr:= FNVALIDACARACSPEI(Par_NombreOrd);
			IF (Par_NumErr = 100)THEN
				SET Par_NumErr = 013;
				SET Par_ErrMen ='Caracter invalido';
				SET Var_Control=  'Devolucion' ;
				LEAVE ManejoErrores;
			END IF;

			SET Par_NumErr:= FNVALIDACARACSPEI(Par_RFCOrd);
			IF ( Par_NumErr= 100)THEN
				SET Par_NumErr = 013;
				SET Par_ErrMen ='Caracter invalido';
				SET Var_Control=  'Devolucion' ;
				LEAVE ManejoErrores;
			END IF;

			-- VALIDACIONES PARA ELBENEFICIARIO UNO

			SET Par_NumErr:= FNVALIDACARACSPEI(Par_NombreBeneficiario);
			IF (Par_NumErr = 100)THEN
				SET Par_NumErr = 013;
				SET Par_ErrMen ='Caracter invalido';
				SET Var_Control=  'Devolucion' ;
				LEAVE ManejoErrores;
			END IF;

			SET  Par_NumErr:= FNVALIDACARACSPEI(Par_RFCBeneficiario);
			IF (Par_NumErr = 100)THEN
				SET Par_NumErr = 013;
				SET Par_ErrMen ='Caracter invalido';
				SET Var_Control=  'Devolucion' ;
				LEAVE ManejoErrores;
			END IF;

			SET Par_NumErr:= FNVALIDACARACSPEI(Par_ConceptoPago);
			IF (Par_NumErr = 100)THEN
				SET Par_NumErr = 013;
				SET Par_ErrMen ='Caracter invalido';
				SET Var_Control=  'Devolucion' ;
				LEAVE ManejoErrores;
			END IF;
		END IF;-- fin validaciones tipo de pago

	END IF;-- END IF del tipo de pago diferente de 0

	-- VALIDACIONES SI EL TIPO DE PAGO ES 0 (DEVOLUCION)
	IF(Par_TipoPago = Entero_Cero) THEN
		SET Par_NumErr	:= 080;
		SET Par_ErrMen	:='Tipo de pago erroneo';
		SET Var_Control	:=  'tipoPago' ;
		LEAVE ManejoErrores;
	END IF;

	IF (Par_TipoPago = Tp_Remesa) THEN
		SET Var_CuentaAho := Par_CuentaAhoID;
	END IF;

-- ----------------------FIN VALIDACIONES-------------------------------

-- Si la referencia cobranza viene nula se setea con un valor vacio
SET Par_ReferenciaCobranza := IFNULL(Par_ReferenciaCobranza, Cadena_Vacia);

-- Si el tipo de pago es diferente de 4 el tipo de operacion va vacio.
SET Par_TipoOperacion := IFNULL(Par_TipoOperacion, Entero_Cero);

-- Si el beneficiario dos no existe se setean todos los parametros del beneficiario dos a 0 o valores vacios.
SET Par_CuentaBenefiDos := IFNULL(Par_CuentaBenefiDos, Entero_Cero);
SET Par_NombreBenefiDos := IFNULL(Par_NombreBenefiDos, Cadena_Vacia);
SET Par_RFCBenefiDos := IFNULL(Par_RFCBenefiDos, Cadena_Vacia);
SET Par_TipoCuentaBenDos := IFNULL(Par_TipoCuentaBenDos, Entero_Cero);
SET Par_ConceptoPagoDos := IFNULL(Par_ConceptoPagoDos, Cadena_Vacia);

-- se setea la fecha de autorizacion a fecha vacia
SET Var_FechaAut  := Fecha_Vacia;

-- se setea estatus recepcion P pendiente por autorizar
SET Var_Estatus := Est_Pen;

-- se setea causa devolucion con valor cero
SET Par_CausaDevol := IFNULL(Par_CausaDevol, Entero_Cero);


SET Par_ComisionTrans := IFNULL(Par_ComisionTrans,Decimal_Cero);
SET Par_IVAComision := IFNULL(Par_IVAComision,Decimal_Cero);
SET Var_TotCta :=(Par_MontoTransferir+Par_ComisionTrans+Par_IVAComision);

SET Var_UsuarioAut := IFNULL(Var_UsuarioAut,Cadena_Vacia);
SET Var_FolioSpei := IFNULL(Var_FolioSpei,Entero_Cero);
SET Var_CuentaAho := IFNULL(Var_CuentaAho,Entero_Cero)  ;

SET Aud_FechaActual := NOW();

-- NUMERO CONSECUTIVO DE SPEIREMESAS
SET Var_FolioSpei := (SELECT IFNULL(MAX(SpeiRemID),Entero_Cero) + 1
FROM SPEIREMESAS);

INSERT INTO SPEIREMESAS (
	SpeiRemID,							ClaveRastreo,						TipoPagoID,								CuentaAho,								TipoCuentaOrd,
	CuentaOrd,							NombreOrd,							RFCOrd,									MonedaID,								TipoOperacion,
	MontoTransferir,					IVAPorPagar,						ComisionTrans,							IVAComision,							TotalCargoCuenta,
	InstiRemitenteID,					InstiReceptoraID,					CuentaBeneficiario,						NombreBeneficiario,						RFCBeneficiario,
	TipoCuentaBen,						ConceptoPago,						CuentaBenefiDos,						NombreBenefiDos,						RFCBenefiDos,
	TipoCuentaBenDos,					ConceptoPagoDos,					ReferenciaCobranza,						ReferenciaNum,							PrioridadEnvio,
	FechaAutorizacion,					EstatusRem,							UsuarioEnvio,							AreaEmiteID,							Estatus,
	UsuarioAutoriza,					FolioSpei,							FechaRecepcion,							CausaDevol,								Topologia,
	Folio,								FolioPaquete,						FolioServidor,							Firma,									SpeiDetSolDesID,
	SpeiSolDesID,						SucursalOpera,						EmpresaID,								Usuario,								FechaActual,
	DireccionIP,						ProgramaID,							Sucursal,								NumTransaccion)
VALUES(
	Var_FolioSpei,						Par_ClaveRastreo,					Par_TipoPago,							Var_CuentaAho,							Par_TipoCuentaOrd,
	FNENCRYPTSAFI(Par_CuentaOrd),		FNENCRYPTSAFI(Par_NombreOrd),		FNENCRYPTSAFI(Par_RFCOrd),				Mon_Pesos,								Par_TipoOperacion,
	FNENCRYPTSAFI(Par_MontoTransferir), Par_IVA,							Par_ComisionTrans,						Par_IVAComision,						FNENCRYPTSAFI(Var_TotCta),
	Par_InstiRemitente,					Par_InstiReceptora,					FNENCRYPTSAFI(Par_CuentaBeneficiario),	FNENCRYPTSAFI(Par_NombreBeneficiario),	FNENCRYPTSAFI(Par_RFCBeneficiario),
	Par_TipoCuentaBen,					FNENCRYPTSAFI(Par_ConceptoPago),	Par_CuentaBenefiDos,					Par_NombreBenefiDos,					Par_RFCBenefiDos,
	Par_TipoCuentaBenDos,				Par_ConceptoPagoDos,				Par_ReferenciaCobranza,					Par_ReferenciaNum,						Par_Prioridad,
	Var_FechaAut,						Par_EstatusRem,						Par_UsuarioEnvio,						Par_AreaEmiteID,						Var_Estatus,
	Var_UsuarioAut,						Var_FolioSpei,						Par_FechaRecepcion,						Par_CausaDevol,							Par_Topologia,
	Par_Folio,							Par_FolioPaquete,					Par_FolioServidor,						Par_Firma,								Par_SpeiDetSolDesID,
	Par_SpeiSolDesID,					Aud_Sucursal,						Par_EmpresaID,							Aud_Usuario,							Aud_FechaActual,
	Aud_DireccionIP,					Aud_ProgramaID,						Aud_Sucursal,							Aud_NumTransaccion);

	SET Par_NumErr	:= 000;
	SET Par_ErrMen	:= CONCAT("Remesa SPEI Agregada Exitosamente: ", CONVERT(Var_FolioSpei, CHAR));
	SET Var_Control	:= 'numero' ;
	SET Var_Consecutivo	:=Var_FolioSpei;

END ManejoErrores;

	IF (Par_Salida = Salida_SI) THEN
		SELECT  Par_NumErr AS NumErr,
		Par_ErrMen AS ErrMen,
		Var_Control AS control,
		Var_Consecutivo AS consecutivo;
	END IF;

END TerminaStore$$