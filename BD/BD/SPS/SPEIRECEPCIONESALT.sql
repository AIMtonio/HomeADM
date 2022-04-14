DELIMITER ;

DROP PROCEDURE IF EXISTS `SPEIRECEPCIONESALT`;

DELIMITER $$

CREATE PROCEDURE `SPEIRECEPCIONESALT`(
-- ========================================================================
-- ------- STORE PARA DAR DE ALTA UNA RECEPCION SPEI ---------
-- ========================================================================
	INOUT Par_FolioSpei		BIGINT(20),					-- Numero de recepcion
	Par_TipoPago			INT(2),						-- Tipo de pago
	Par_TipoCuentaOrd	   	INT(2),						-- Tipo de cuenta ordenante
	Par_CuentaOrd		   	VARCHAR(20),				-- Cuenta del Ordenante
	Par_NombreOrd		   	VARCHAR(40),                -- Nombre del ordenante

	Par_RFCOrd	           	VARCHAR(18),				-- RFC del ordenante
	Par_TipoOperacion	   	INT(2),						-- Tipo de Operacion
	Par_MontoTransferir	   	DECIMAL(16,2),				-- Monto a transferir
	Par_IVA				   	DECIMAL(16,2),		        -- IVA por pagar
	Par_InstiRemitente	   	INT(5),						-- Institucion Remitente

	Par_InstiReceptora	   	INT(5),						-- Institucion Receptora
	Par_CuentaBeneficiario 	VARCHAR(20),				-- Cuenta del beneficiario
	Par_NombreBeneficiario 	VARCHAR(40),		        -- Nombre del beneficiario
	Par_RFCBeneficiario	   	VARCHAR(18),			    -- RFC 	del beneficiario
	Par_TipoCuentaBen	   	INT(2),                     -- Tipo de Cuenta del beneficiario

	Par_ConceptoPago	   	VARCHAR(210),				-- Concepto de Pago
	Par_ClaveRastreo	   	VARCHAR(30),                -- Clave de ratreo
	Par_CuentaBenefiDos    	VARCHAR(20),				-- Cuenta del segundo beneficiario
	Par_NombreBenefiDos    	VARCHAR(40),		        -- Nombre del segundo beneficiario
	Par_RFCBenefiDos	   	VARCHAR(18),	            -- RFC 	del segundo beneficiario

	Par_TipoCuentaBenDos   	INT(2),						-- Tipo de Cuenta del segundo beneficiario
	Par_ConceptoPagoDos    	VARCHAR(40),				-- Concepto de Pago	Dos
	Par_ClaveRastreoDos	   	VARCHAR(30),		        -- Clave de ratreo dos
	Par_ReferenciaCobranza 	VARCHAR(40),		        -- Referencia de cobranza
	Par_ReferenciaNum      	INT(7),	                    -- Referencia numerica

	Par_Prioridad    	   	INT(1),						-- Prioridad del envio
	Par_FechaCaptura       	DATETIME,					-- fecha de captura
	Par_ClavePago          	VARCHAR(10),				-- clave de pago
	Par_AreaEmiteID	       	INT(2),						-- Area emitente
	Par_EstatusRecep       	INT(3),						-- estatus recepcion

	Par_CausaDevol         	INT(2),						-- Causa devolucion
	Par_InfAdicional       	VARCHAR(100),               -- Informacion adicional
	Par_Firma              	VARCHAR(250),               -- Firma
	Par_Folio              	BIGINT(20),                 -- Folio
	Par_FolioBanxico       	BIGINT(20),                 -- Folio Banxico

	Par_FolioPaquete       	BIGINT(20),					-- folio paquete
	Par_FolioServidor      	BIGINT(20),					-- folio servidor
	Par_Topologia          	CHAR(1),					-- topologia

	Par_Salida			   	CHAR(1), 					-- Salida
	INOUT Par_NumErr	   	INT(11),                    -- Numero de error
	INOUT Par_ErrMen	   	VARCHAR(350),               -- Mensaje de error

	Par_EmpresaID		   	INT(11),                    -- EmpresaID
	Aud_Usuario			   	INT(11),                    -- UsuarioID
	Aud_FechaActual		   	DATETIME,                   -- Fecha Actual
	Aud_DireccionIP		   	VARCHAR(20),                -- DireccionIP
	Aud_ProgramaID		   	VARCHAR(50),                -- ProgramaID
	Aud_Sucursal		   	INT(11),                    -- SucursalID
	Aud_NumTransaccion	   	BIGINT(20)	                -- Numero de transaccion
)
TerminaStore: BEGIN

	-- Declaracion de Constantes
	DECLARE	Cadena_Vacia	CHAR(1);
	DECLARE	Entero_Cero		INT(11);
	DECLARE	Decimal_Cero	DECIMAL(18,2);
	DECLARE	Fecha_Vacia		DATE;
	DECLARE Salida_SI 		CHAR(1);
	DECLARE	Salida_NO		CHAR(1);
	DECLARE	Num_Uno 		INT(1);
	DECLARE RepOper     	CHAR(1);
	DECLARE Est_Reg         CHAR(1);
	DECLARE Fecha_Sist      DATE;

	-- Declaracion de Variables
	DECLARE Var_Control	    VARCHAR(200);   		-- Variable de control
	DECLARE Var_Consecutivo	BIGINT(20);     		-- Variable consecutivo
	DECLARE tipoPagoCua		INT(2);         		-- Tipo pago sea 4
	DECLARE Var_CantNega    DECIMAL(18,2);  		-- cantidad negativa
	DECLARE Var_FechaOpe    DATE;       			-- fecha operacion
	DECLARE Var_Estatus     CHAR(1);        		-- estatus safi
	DECLARE ImporteMaximo   DECIMAL(18,2);  		-- Importe maximo para tranferir spei

	-- Asignacion de Constantes
	SET	Cadena_Vacia	:= '';             			-- Cadena Vacia
	SET	Fecha_Vacia		:= '1900-01-01';   			-- Fecha Vacia
	SET	Entero_Cero		:= 0;              			-- Entero Cero
	SET	Decimal_Cero	:= 0.0;            			-- DECIMAL cero
	SET Salida_SI 	   	:= 'S';            			-- Salida SI
	SET	Salida_NO		:= 'N';           			-- Salida NO
	SET	Num_Uno 		:= 1;             			-- Numero uno
	SET tipoPagoCua     := 4;              			-- tipo de pago sea 4
	SET ImporteMaximo   := 999999999999.99; 		-- importe maximo para las transferencias spei
	SET	RepOper       	:= 'N';			   			-- No se ha reportado la operacion a Banxico
	SET Est_Reg         := 'R';            			-- Estatus registrada

	ManejoErrores:BEGIN

		DECLARE EXIT HANDLER FOR SQLEXCEPTION
			BEGIN
				SET Par_NumErr	= 999;
				SET Par_ErrMen	= CONCAT('El SAFI ha tenido un problema al concretar la operacion. ',
									'Disculpe las molestias que esto le ocasiona. Ref: SP-SPEIRECEPCIONESSALT');
				SET Var_Control = 'SQLEXCEPTION';
			END;

		SET Fecha_Sist      := (SELECT FechaSistema FROM PARAMETROSSIS);

		-- si el tipo de pago es 4 entonces se valida que el tipo de operacion no sea vacio

		IF EXISTS (SELECT ClaveRastreo
				   FROM SPEIRECEPCIONES
				   WHERE ClaveRastreo = Par_ClaveRastreo
                   AND FechaOperacion = Fecha_Sist)THEN
			SET Par_NumErr	:= 001;
			SET Par_ErrMen	:='Clave de Rastreo ya existe';
			SET Var_Control	:=  'claveRastreo' ;
			LEAVE ManejoErrores;
		END IF;

		IF(Par_TipoPago = tipoPagoCua)THEN
			IF(IFNULL(Par_TipoOperacion,Entero_Cero))= Entero_Cero THEN
				SET Par_NumErr := 005;
				SET Par_ErrMen :='El Tipo de Operacion esta Vacio.';
				SET Var_Control	:=  'tipoOperacion' ;
				LEAVE ManejoErrores;
			END IF;
		END IF;

		-- VALIDACION QUE EL MONTO A TRANSFERIR SEA MAYOR AL PERMITIDO POR SPEI
		IF (Par_MontoTransferir > ImporteMaximo) THEN
			SET Par_NumErr 	:= 011;
			SET Par_ErrMen 	:='El Monto es mayor al monto permitido.';
			SET Var_Control	:=  'montoTransferir' ;
			LEAVE ManejoErrores;
		END IF;

		-- Si la referencia cobranza viene nula se setea con un valor vacio
		SET Par_ReferenciaCobranza	:= IFNULL(Par_ReferenciaCobranza, Cadena_Vacia);

		-- Si el tipo de pago es diferente de 4 el tipo de operacion va vacio.
		SET Par_TipoOperacion		:= IFNULL(Par_TipoOperacion, Entero_Cero);

		-- Si el beneficiario dos no existe se setean todos los parametros del beneficiario dos a 0 o valores vacios.
		SET Par_CuentaBenefiDos		:= IFNULL(Par_CuentaBenefiDos, Entero_Cero);
		SET Par_NombreBenefiDos 	:= IFNULL(Par_NombreBenefiDos, Cadena_Vacia);
		SET Par_RFCBenefiDos		:= IFNULL(Par_RFCBenefiDos, Cadena_Vacia);
		SET Par_TipoCuentaBenDos	:= IFNULL(Par_TipoCuentaBenDos, Entero_Cero);
		SET Par_ConceptoPagoDos		:= IFNULL(Par_ConceptoPagoDos, Cadena_Vacia);
		SET Par_ClaveRastreoDos		:= IFNULL(Par_ClaveRastreoDos, Cadena_Vacia);

		-- Si la clave de pago viene nula se setea con un valor vacio
		SET Par_ClavePago	:= IFNULL(Par_ClavePago, Cadena_Vacia);

		-- se setea la fecha de operaciona  fecha del sistema
		SET Var_FechaOpe	:= Fecha_Sist;

		-- se setea estatus recepcion con 1
		SET Var_Estatus		:= Est_Reg;

		-- se setea causa devolucion con valor cero
		SET Par_CausaDevol	:= IFNULL(Par_CausaDevol, Entero_Cero);

		-- Si la inf adicional viene nula se setea con un valor vacio
		SET Par_InfAdicional:= IFNULL(Par_InfAdicional, Cadena_Vacia);

		SET Aud_FechaActual	:= CURRENT_TIMESTAMP();

		-- SE SETEA EL VALOR DEL FOLIO DE PARAMETROS INCREMENTANDO EN 1
		SET Par_FolioSpei	:= (SELECT IFNULL(MAX(FolioEnvio),Entero_Cero) + 1 FROM PARAMETROSSPEI);

		-- Se actualiza el campo en la tabla PARAMETROSSPEI
		UPDATE PARAMETROSSPEI SET
		FolioEnvio	= Par_FolioSpei;


		INSERT INTO SPEIRECEPCIONES (
			FolioSpeiRecID,						TipoPagoID,								TipoCuentaOrd,							CuentaOrd,							NombreOrd,
			RFCOrd,								TipoOperacion,							MontoTransferir,						IVAComision,						InstiRemitenteID,
			InstiReceptoraID,					CuentaBeneficiario,						NombreBeneficiario,						RFCBeneficiario,					TipoCuentaBen,
			ConceptoPago,						ClaveRastreo,							CuentaBenefiDos,						NombreBenefiDos,					RFCBenefiDos,
			TipoCuentaBenDos,					ConceptoPagoDos,						ClaveRastreoDos,						ReferenciaCobranza,					ReferenciaNum,
			Estatus,							Prioridad,								FechaOperacion,							FechaCaptura,						ClavePago,
			AreaEmiteID,						EstatusRecep,							CausaDevol,								InfAdicional,						RepOperacion,
			Firma,								Folio,									FolioBanxico,							FolioPaquete,						FolioServidor,
			Topologia,							Empresa,								EmpresaID,								Usuario,							FechaActual,
			DireccionIP,						ProgramaID,								Sucursal,								NumTransaccion)
		VALUES(
			Par_FolioSpei,						Par_TipoPago,							Par_TipoCuentaOrd,						FNENCRYPTSAFI(Par_CuentaOrd),		FNENCRYPTSAFI(Par_NombreOrd),
			FNENCRYPTSAFI(Par_RFCOrd),			Par_TipoOperacion,						FNENCRYPTSAFI(Par_MontoTransferir),		Par_IVA,							Par_InstiRemitente,
			Par_InstiReceptora,					FNENCRYPTSAFI(Par_CuentaBeneficiario),	FNENCRYPTSAFI(Par_NombreBeneficiario),	FNENCRYPTSAFI(Par_RFCBeneficiario),	Par_TipoCuentaBen,
			FNENCRYPTSAFI(Par_ConceptoPago),	Par_ClaveRastreo,						Par_CuentaBenefiDos,					Par_NombreBenefiDos,				Par_RFCBenefiDos,
			Par_TipoCuentaBenDos,				Par_ConceptoPagoDos,					Par_ClaveRastreoDos,					Par_ReferenciaCobranza,				Par_ReferenciaNum,
			Var_Estatus,						Par_Prioridad,							Var_FechaOpe,							Par_FechaCaptura,					Par_ClavePago,
			Par_AreaEmiteID,					Par_EstatusRecep,						Par_CausaDevol,							Par_InfAdicional,					RepOper,
			Par_Firma,							Par_Folio,								Par_FolioBanxico,						Par_FolioPaquete,					Par_FolioServidor,
			Par_Topologia,						Cadena_Vacia,							Par_EmpresaID,							Aud_Usuario,						Aud_FechaActual,
			Aud_DireccionIP,					Aud_ProgramaID,							Aud_Sucursal,							Aud_NumTransaccion);

		SET Par_NumErr	:= 000;
		SET Par_ErrMen	:= CONCAT("Recepcion SPEI Agregado Exitosamente: ", CONVERT(Par_FolioSpei, CHAR));
		SET Var_Control	:= 'numero' ;
		SET Var_Consecutivo	:=Par_FolioSpei;

	END ManejoErrores;

		IF (Par_Salida = Salida_SI) THEN
			SELECT  Par_NumErr AS NumErr,
					Par_ErrMen AS ErrMen,
					Var_Control AS control,
					Var_Consecutivo AS consecutivo;
		END IF;

END TerminaStore$$