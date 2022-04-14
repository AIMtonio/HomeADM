-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- DISPERSIONANTFAPRO
DELIMITER ;
DROP PROCEDURE IF EXISTS `DISPERSIONANTFAPRO`;DELIMITER $$

CREATE PROCEDURE `DISPERSIONANTFAPRO`(
# =================================================================================================
# ---- SP PARA IMPORTAR LOS ANTICIPOS QUE SE ENCUENTRAN REGISTRADOS Y NO HAYAN SIDO DIPERSADOS-----
# =================================================================================================
	Par_InstitucionID 	INT(11),
	Par_NumCtaInstit 	VARCHAR(20),
	Par_Fecha			DATE,

	Par_Salida			CHAR(1),
	INOUT Par_NumErr	INT(11),
	INOUT Par_ErrMen	VARCHAR(400),

	Par_EmpresaID		INT(11),
	Aud_Usuario			INT(11),
	Aud_FechaActual		DATETIME,
	Aud_DireccionIP		VARCHAR(15),
	Aud_ProgramaID		VARCHAR(50),
	Aud_Sucursal		INT(11),
	Aud_NumTransaccion	BIGINT(20)
)
TerminaStore: BEGIN

	-- Declaracion de Constantes
	DECLARE Cadena_Vacia      		CHAR(1);
	DECLARE Fecha_Vacia				DATE;
	DECLARE Entero_Cero				INT(11);
	DECLARE Decimal_Cero			DECIMAL(12,4);
	DECLARE SalidaSi				CHAR(1);
	DECLARE SalidaNo				CHAR(1);
	DECLARE PerFisica				CHAR(1);
	DECLARE PerMoral				CHAR(1);
	DECLARE Descrip					VARCHAR(50);
	DECLARE EstatusPendien			CHAR(1);
	DECLARE Var_SI					CHAR(1);
	DECLARE FormaPagoSPEI     		INT(11);		-- Forma de pago con SPEI
	DECLARE FormaPagoCheque			INT(11);		-- Forma de pago con cheque
	DECLARE FormaPagoBanE     		INT(11);		-- Forma de pago Banca electronica
	DECLARE FormaPagoTarE			INT(11);		-- Forma de pago Tarjeta Empresarial
	DECLARE Est_Autorizado			CHAR(1); 		-- Corresponde con el estatus de la tabla REQGASTOSUCURMOV
	DECLARE Act_FolioDisper			INT(11);		-- indica el numero de actualizacion que se hara para los movimientos de req.


	-- tipos de movimientos de la tabla TIPOSMOVTESO
	DECLARE Var_SPEIProvAntFact	 	CHAR(4);
	DECLARE Var_CheqProvAntFact	 	CHAR(4);
	DECLARE Var_TipoBanEAntFac		CHAR(4);
	DECLARE Var_TipoTarEAntFac		CHAR(4);

	-- Tipo de deposito de la tabla ANTICIPOFACTURA
	DECLARE Efectivo				CHAR(1);
	DECLARE Cheque		    		CHAR(1);
	DECLARE Spei		     		CHAR(1);
	DECLARE BancaElec				CHAR(1);
	DECLARE TarjetaEmp				CHAR(1);
	DECLARE	Act_DisperAlta			INT(11);


	-- Declaracion de Variables
	DECLARE Var_NumSucursal			INT(11);
	DECLARE NumError				INT(11);
	DECLARE ErrorMen				VARCHAR(200);
	DECLARE Var_Institucion			INT(11);
	DECLARE Var_CtaInstitu			VARCHAR(20);
	DECLARE FolioOperac				INT(11);
	DECLARE numeroAntFact			INT(11); -- variable para saber si existen o no anticipos por dispersar
	DECLARE Var_FormaPago			INT(11);
	DECLARE TipoMovDis				CHAR(4);
	DECLARE Var_FechaSistema		DATE;
	DECLARE Var_Referencia			VARCHAR(50);
	DECLARE RegistroSalida			INT(11);
	DECLARE Var_DetReqGasID			INT(11);
	-- variables para el cursor
	DECLARE Var_AnticipoFactID		INT(11);
	DECLARE Var_NumReqGasID			INT(11);
	DECLARE Var_TipoGastoID			INT(11);
	DECLARE Var_NoFactura			VARCHAR(20);
	DECLARE Var_MontoAut			DECIMAL(12,2);
	DECLARE Var_TipoDeposito		CHAR(1);
	DECLARE Var_ProveedorID			INT(11);
	DECLARE Var_FacturaProvID		INT(11);
	-- variables para datos de proveedores
	DECLARE Var_ProveedorNom		VARCHAR(200);
	DECLARE Var_RFC					VARCHAR(13);
	DECLARE Var_CuentaClabe			VARCHAR(18);
	DECLARE Fecha					DATE;
	DECLARE SiHabilita				CHAR(1);
	DECLARE ValorParam				VARCHAR(100);
	DECLARE Var_SiHabilita			CHAR(1);
    DECLARE Var_Control				VARCHAR(100);
    DECLARE Var_TipoChequera		CHAR(2);

	DECLARE CURSORANTICIPOFAC CURSOR FOR -- Cursor para Anticipos de Facturas del Proveedor
		 SELECT 	MAX(Ant.AnticipoFactID),	Ant.NoFactura,	SUM(Ant.MontoAnticipo) AS MontoAnticipo,	MAX(Ant.FormaPago),	Ant.ProveedorID
			FROM ANTICIPOFACTURA Ant
			WHERE 		EstatusAnticipo = 'R'
			AND 		ClaveDispMov	= 0
			AND 		FormaPago 		<> 'E'
			GROUP BY 	Ant.NoFactura, Ant.ProveedorID;

	-- Cursor para Anticipos de Facturas, actualizarÃ¡ cada una de los anticipos que sean de factura
	 DECLARE CURSORACTUALIZAFAC CURSOR FOR
		 SELECT 	Ant.AnticipoFactID,
					Ant.NoFactura,  Ant.MontoAnticipo,
					Ant.FormaPago,	Ant.ProveedorID
			FROM ANTICIPOFACTURA Ant
			WHERE 		EstatusAnticipo = 'R'
			AND 		ClaveDispMov	= 0
			AND 		FormaPago 		<> 'E';


	-- Asignacion de Constantes
	SET Entero_Cero			:= 0;
	SET Decimal_Cero		:= 0.0;
	SET Cadena_Vacia		:= '';
	SET SalidaSi         	:= 'S';
	SET SalidaNo         	:= 'N';
	SET PerFisica        	:= 'F';
	SET PerMoral         	:= 'M';
	SET EstatusPendien   	:= 'P';
	SET FormaPagoSPEI    	:= 1;
	SET FormaPagoCheque  	:= 2;
	SET FormaPagoBanE  		:= 3;
	SET FormaPagoTarE  		:= 4;
	SET Est_Autorizado		:= 'A';
	SET Var_SI				:= 'S';

	-- Forma de pago de la tabla ANTICIPOFACTURA
	SET Efectivo			:= 'E';
	SET Cheque				:= 'C';
	SET Spei				:= 'S';
	SET BancaElec			:= 'B';
	SET TarjetaEmp			:= 'T';

	-- tipos de movimientos de la tabla TIPOSMOVTESO
	SET Var_SPEIProvAntFact	:= '22';			-- TIPOSMOVTESO: Salida SPEI por Anticipo Pago a Provedores Factura
	SET Var_CheqProvAntFact	:= '23';			-- TIPOSMOVTESO: Salida Cheque por Anticipo Pago a Provedores Factura
	SET Var_TipoBanEAntFac	:= '24';			-- TIPOSMOVTESO Salida de Recursos Banca Electronica por Anticipo  Pago a Provedores Factura
	SET Var_TipoTarEAntFac	:= '25';			-- TIPOSMOVTESO Salida de Recursos Tarjeta Empresarial por Anticipo  Pago a Provedores Factura
	SET Act_DisperAlta		:= 3;

	SET Var_FechaSistema 	:= (SELECT FechaSistema FROM PARAMETROSSIS);
	SET SiHabilita			:="S";
	SET ValorParam			:="HabilitaFechaDisp";

	ManejoErrores:BEGIN

		DECLARE EXIT HANDLER FOR SQLEXCEPTION
			BEGIN
				SET Par_NumErr = 999;
				SET Par_ErrMen = CONCAT('El SAFI ha tenido un problema al concretar la operacion. Disculpe las molestias que ',
									  'esto le ocasiona. Ref: SP-DISPERSIONANTFAPRO');
				END;

		SELECT ValorParametro INTO Var_SiHabilita
			FROM PARAMGENERALES WHERE LlaveParametro=ValorParam;

		IF Var_SiHabilita=SiHabilita THEN
			SET Fecha :=Par_Fecha;
		ELSE
			SET Fecha :=Var_FechaSistema;
		END IF;


		-- se obtiene el numero de anticipos registrados  que cumplan con la condicion
		SET numeroAntFact :=(SELECT 	COUNT(Ant.AnticipoFactID)
								FROM ANTICIPOFACTURA Ant
									WHERE 		EstatusAnticipo = 'R'
									AND 		ClaveDispMov	= 0
									AND 		FormaPago 		<> 'E');

		-- Si el valor fuera nulo se  convierte a cero
		SET numeroAntFact := IFNULL(numeroAntFact, Entero_Cero);

		IF(IFNULL(numeroAntFact,Entero_Cero)) = Entero_Cero THEN
			SET Par_NumErr	:= 001;
			SET Par_ErrMen	:= 'No Hay Anticipos Autorizados para Importar';
			SET Var_Control	:= 'folioOperacion';
			LEAVE ManejoErrores;
		END IF;

		IF(IFNULL(Par_EmpresaID,Entero_Cero)) = Entero_Cero THEN
			SET Par_NumErr	:= 001;
			SET Par_ErrMen	:= 'La Empresa esta vacia';
			SET Var_Control	:= '';
			LEAVE ManejoErrores;
		END IF;



		-- se valida que existe el numero de institucion
		SET Var_Institucion := IFNULL((SELECT InstitucionID
										FROM INSTITUCIONES
										WHERE InstitucionID= Par_InstitucionID ),Entero_Cero);

		IF(IFNULL(Var_Institucion,Entero_Cero)) = Entero_Cero THEN
			SET Par_NumErr	:= 001;
			SET Par_ErrMen	:= 'La Institucion especificada no Existe';
			SET Var_Control	:= 'institucionID';
			LEAVE ManejoErrores;
		END IF;

		-- Se asigna valor para numero de cuenta interno
		SET Var_CtaInstitu := IFNULL((SELECT CuentaAhoID
										FROM 	CUENTASAHOTESO
										WHERE 	InstitucionID	= Par_InstitucionID
										AND 	NumCtaInstit	= Par_NumCtaInstit),Cadena_Vacia);

		IF(IFNULL(Var_CtaInstitu,Cadena_Vacia)) = Cadena_Vacia THEN
			SET Par_NumErr	:= 001;
			SET Par_ErrMen	:= 'La Cuenta Bancaria especificada no Existe';
			SET Var_Control	:= 'numCtaInstit';
			LEAVE ManejoErrores;
		END IF;

		SET Aud_FechaActual := CURRENT_TIMESTAMP();

		-- Si existen anticipos autorizados inserta el encabezado de la dispersion
		IF ( IFNULL(numeroAntFact,Entero_Cero) > Entero_Cero) THEN
			-- se inserta el encabezado de la dispersion.
			CALL DISPERSIONALT(
				Fecha,				Var_Institucion,    Var_CtaInstitu,     Par_NumCtaInstit,		SalidaNo,
				Par_NumErr, 		Par_ErrMen,         FolioOperac,        Par_EmpresaID,      	Aud_Usuario,
				Aud_FechaActual,	Aud_DireccionIP,    Aud_ProgramaID,     Aud_Sucursal,       	Aud_NumTransaccion);

			IF(Par_NumErr != Entero_Cero)THEN
				SET Par_NumErr	:= 001;
				SET Par_ErrMen	:= 'Error en generar el folio de Dispersion';
				SET Var_Control	:= '';
				LEAVE ManejoErrores;
			END IF;


		-- ***********  inicio Cursor para Facturas *********

			OPEN CURSORANTICIPOFAC;
			BEGIN
				DECLARE EXIT HANDLER FOR SQLSTATE '02000' BEGIN END;
				CICLO:LOOP
				FETCH CURSORANTICIPOFAC 	INTO
					Var_AnticipoFactID,	Var_NoFactura,	Var_MontoAut,		Var_TipoDeposito,	Var_ProveedorID;

				-- se obtienen los valores que se ocupan de proveedores
				SET Var_ProveedorNom := (SELECT	CASE TipoPersona
															WHEN  PerFisica	THEN CONCAT(IFNULL(PrimerNombre,''),CASE WHEN CHAR_LENGTH(IFNULL(TRIM(SegundoNombre),''))>0 THEN CONCAT(" ", TRIM(SegundoNombre)) ELSE '' END , CASE WHEN CHAR_LENGTH(IFNULL(TRIM(ApellidoPaterno),''))>0 THEN CONCAT(" ", TRIM(ApellidoPaterno)) ELSE '' END,CASE WHEN CHAR_LENGTH(IFNULL(TRIM(ApellidoMaterno),''))>0 THEN CONCAT(" ", TRIM(ApellidoMaterno)) ELSE '' END)
															WHEN  PerMoral	THEN RazonSocial
													END AS Proveedor
											FROM PROVEEDORES
											WHERE ProveedorID = Var_ProveedorID);

				-- se obtienen los valores que se ocupan de proveedores
				SET Var_RFC := (SELECT	CASE TipoPersona
												WHEN  PerFisica	THEN RFC
												WHEN  PerMoral	THEN RFCpm
										END AS RFC
								FROM PROVEEDORES
								WHERE ProveedorID = Var_ProveedorID);

				-- se obtienen los valores que se ocupan de proveedores
				SET Var_CuentaClabe := (SELECT	CuentaClave
											FROM PROVEEDORES
											WHERE ProveedorID = Var_ProveedorID);

				-- se asigna el tipo de movimiento que corresponde para cada forma de pago
				CASE Var_TipoDeposito
					WHEN Cheque		THEN
						SET TipoMovDis 		:= Var_CheqProvAntFact;
						SET Var_FormaPago	:= FormaPagoCheque;
						SET Var_CuentaClabe := Cadena_Vacia;
                        SET Var_TipoChequera:= Cadena_Vacia;
					WHEN Spei		THEN
						SET TipoMovDis 		:= Var_SPEIProvAntFact;
						SET Var_FormaPago	:= FormaPagoSPEI;
                        SET Var_TipoChequera:= Cadena_Vacia;
					WHEN BancaElec	THEN
						SET TipoMovDis		:= Var_TipoBanEAntFac;
						SET Var_FormaPago	:= FormaPagoBanE;
						SET Var_CuentaClabe := Cadena_Vacia;
                        SET Var_TipoChequera:= Cadena_Vacia;
					WHEN TarjetaEmp	THEN
						SET TipoMovDis 		:= Var_TipoTarEAntFac;
						SET Var_FormaPago	:= FormaPagoTarE;
						SET Var_CuentaClabe := Cadena_Vacia;
                        SET Var_TipoChequera:= Cadena_Vacia;
				END CASE;

				SET Var_ProveedorNom:=SUBSTRING(Var_ProveedorNom,1,25);
				SET Descrip	:= CONCAT('PAGO ANTICIPO PROVEEDOR ', Var_ProveedorNom);


				SET Var_Referencia := Var_NoFactura;
				SET Var_FacturaProvID := (SELECT 	FacturaProvID
											FROM 	FACTURAPROV
											WHERE 	NoFactura = Var_NoFactura
											AND 	ProveedorID=Var_ProveedorID);


				SET Var_NumSucursal := Aud_Sucursal;

				SET Var_DetReqGasID	:= (SELECT 	max(DetReqGasID)
										FROM 	REQGASTOSUCURMOV
										WHERE 	NoFactura = Var_NoFactura
										AND 	ProveedorID=Var_ProveedorID);

				CALL DISPERSIONMOVALT(
					FolioOperac,			Entero_Cero,		Cadena_Vacia,		Descrip,				Var_Referencia,
					TipoMovDis, 			Var_FormaPago,		Var_MontoAut, 		Var_CuentaClabe,		Var_ProveedorNom,
					Fecha,					Var_RFC,			EstatusPendien,		SalidaNo,				Var_NumSucursal,
					Entero_Cero,			Var_ProveedorID,	Var_FacturaProvID,	Var_DetReqGasID,		Entero_Cero,
					Entero_Cero,			Var_SI, 			Var_TipoChequera,	Par_NumErr,				Par_ErrMen,
                    RegistroSalida,			Par_EmpresaID,		Aud_Usuario,		Aud_FechaActual,		Aud_DireccionIP,
                    Aud_ProgramaID,			Aud_Sucursal, 		Aud_NumTransaccion);


				IF(Par_NumErr <> Entero_Cero) THEN
					LEAVE CICLO;
				END IF;

				/* se llama sp para actualizar cada anticipo de factura que fueron cargadas para dispersar	*/
				CALL ANTICIPOFACTURACT(
					Entero_Cero,			FolioOperac,		Var_ProveedorID,	Var_NoFactura,		Entero_Cero,
					Act_DisperAlta,			SalidaNo,			Par_NumErr, 		Par_ErrMen, 		Par_EmpresaID,
					Aud_Usuario,			Aud_FechaActual,	Aud_DireccionIP,	Aud_ProgramaID,		Aud_Sucursal,
					Aud_NumTransaccion);
				END LOOP CICLO;
			END;
			CLOSE CURSORANTICIPOFAC;
		END IF;

		SET Par_NumErr 	:= 0;
		SET Par_ErrMen  := CONCAT('Dispersion agregada Exitosamente: ',CONVERT(FolioOperac, CHAR(10)) );
		SET Var_Control := 'folioOperacion';

	END ManejoErrores;

	IF(Par_Salida = SalidaSi) THEN
		SELECT	Par_NumErr	AS NumErr,
				Par_ErrMen	AS ErrMen,
				Var_Control AS control,
				FolioOperac AS consecutivo;
	END IF;

END TerminaStore$$