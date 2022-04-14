-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- DISPERSIONREGTOPRO
DELIMITER ;
DROP PROCEDURE IF EXISTS `DISPERSIONREGTOPRO`;
DELIMITER $$


CREATE PROCEDURE `DISPERSIONREGTOPRO`(
# ==========================================================================
# ---- SP PARA IMPORTAR LAS REQUISICIONES QUE SE ENCUENTREN AUTORIZADAS-----
# ==========================================================================
	Par_InstitucionID 	INT(11),
	Par_NumCtaInstit 	VARCHAR(20),
	Par_Fecha			DATE,
	Par_FechaConsulta	DATE,

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
	DECLARE Cadena_Vacia		CHAR(1);
	DECLARE Fecha_Vacia			DATE;
	DECLARE Entero_Cero			INT(11);
	DECLARE Decimal_Cero		DECIMAL(12,4);
	DECLARE SalidaSi			CHAR(1);
	DECLARE SalidaNo			CHAR(1);
	DECLARE PerFisica			CHAR(1);
	DECLARE PerMoral			CHAR(1);
	DECLARE Var_Descrip			VARCHAR(300);
	DECLARE EstatusPendien		CHAR(1);
	DECLARE FormaPagoSPEI		INT(11);
	DECLARE FormaPagoCheque		INT(11);
	DECLARE FormaPagoBanE		INT(11);		-- Forma de pago Banca electronica
	DECLARE FormaPagoTarE		INT(11);		-- Forma de pago Tarjeta Empresarial
	DECLARE Est_Autorizado		CHAR(1); 		-- Corresponde con el estatus de la tabla REQGASTOSUCURMOV
	DECLARE Act_FolioDisper		INT(11);		-- indica el numero de actualizacion que se hara para los movimientos de req.

	-- tipos de movimientos de la tabla TIPOSMOVTESO
	DECLARE TipoSPEISinFac		CHAR(4);
	DECLARE TipoCheqSinFac		CHAR(4);
	DECLARE TipoSPEIFac			CHAR(4);
	DECLARE TipoCheqFac			CHAR(4);
	DECLARE TipoBanESinFac 		CHAR(4);
	DECLARE TipoBanEFac			CHAR(4);
	DECLARE TipoTarESinFac		CHAR(4);
	DECLARE TipoTarEFac   	 	CHAR(4);

	-- Tipo de deposito de la tabla REQGASTOSUCURMOV
	DECLARE Efectivo			CHAR(1);
	DECLARE Cheque				CHAR(1);
	DECLARE Spei				CHAR(1);
	DECLARE BancaElec			CHAR(1);
	DECLARE TarjetaEmp			CHAR(1);

	-- Declaracion de variables
	DECLARE Var_NumSucursal		INT(11);
	DECLARE Var_Institucion		INT(11);
	DECLARE Var_CtaInstitu		VARCHAR(20);
	DECLARE FolioOperac			INT(11);
	DECLARE numeroReqAut		INT(11); -- VARCHARiable para saber si existen o no requisiciones autorizadas
	DECLARE numeroReqAutSin		INT(11); -- VARCHARiable para saber si existen o no requisiciones autorizadas sin factura
	DECLARE Var_FormaPago		INT(11);
	DECLARE TipoMovDis			CHAR(4);
	DECLARE Var_FechaSistema 	DATE;
	DECLARE Var_Referencia		VARCHAR(50);
	DECLARE Var_Control			VARCHAR(50);
	DECLARE RegistroSalida		INT(11);
	DECLARE Var_Fecha			DATE;
	DECLARE SiHabilita			CHAR(1);
	DECLARE ValorParam			VARCHAR(100);
	DECLARE Var_SiHabilita		CHAR(1);
	-- Variables para el CURSOR
	DECLARE Var_DetReqGasID		INT(11);
	DECLARE Var_NumReqGasID		INT(11);
	DECLARE Var_TipoGastoID		INT(11);
	DECLARE Var_NoFactura		VARCHAR(20);
	DECLARE Var_MontoAut		DECIMAL(12,2);
	DECLARE Var_TipoDeposito	CHAR(1);
	DECLARE Var_ProveedorID		INT(11);
	DECLARE Var_FacturaProvID	INT(11);

	-- Variables para datos de proveedores
	DECLARE Var_ProveedorNom	VARCHAR(200);
	DECLARE Var_RFC				VARCHAR(13);
	DECLARE Var_CuentaClave		VARCHAR(18);
    DECLARE Var_TipoChequera	CHAR(2);

	-- Se declara CURSOR para obtener los valores de las requisiciones autorizadas

	 DECLARE CURSORDISREQGTOFAC CURSOR FOR /* CURSOR para Requisiciones de tipo Factura*/
		SELECT	MAX(Req.DetReqGasID),	MAX(Req.NumReqGasID),	MAX(Req.TipoGastoID),	Req.NoFactura,	SUM(Req.MontoAutorizado) AS MontoAutorizado ,
				MAX(Req.TipoDeposito),	Req.ProveedorID
			FROM 	REQGASTOSUCURMOV Req
            INNER JOIN REQGASTOSUCUR RSU  ON RSU.NumReqGasID = Req.NumReqGasID
			LEFT OUTER JOIN TMPANTICIPOS	AS Ant
					ON	Ant.NoFactura	= Req.NoFactura
					AND	Ant.ProveedorID	= Req.ProveedorID
			INNER JOIN FACTURAPROV FPRO ON Req.ProveedorID = FPRO.ProveedorID AND Req.NoFactura = FPRO.NoFactura
			WHERE  		LTRIM(RTRIM(Req.NoFactura))	<>''
			AND  		Req.Estatus  			= 'A'
			AND 		Req.ClaveDispMov	= 0
			AND 		TipoDeposito 	<> 'E'
			AND 	    IFNULL(Ant.AnticipoFactID,0)=0
           AND CASE
				WHEN Par_FechaConsulta <> Fecha_Vacia THEN
					FPRO.FechaFactura  = Par_FechaConsulta
				ELSE
					TRUE
            END
			GROUP BY Req.NoFactura, Req.ProveedorID;


	 /* CURSOR para Requisiciones de tipo Factura
		Actualizara cada una de las requisiciones
		que  sean de factura
	 */
	DECLARE CURSORACTUALIZAFAC CURSOR FOR
		 SELECT	Req.DetReqGasID,	Req.NumReqGasID,	Req.TipoGastoID,	Req.NoFactura,	Req.MontoAutorizado,
				Req.TipoDeposito,	Req.ProveedorID
			FROM 	REQGASTOSUCURMOV Req
			INNER JOIN REQGASTOSUCUR RSU  ON RSU.NumReqGasID = Req.NumReqGasID
			LEFT OUTER JOIN TMPANTICIPOS AS Ant
				ON	Ant.NoFactura = Req.NoFactura
				AND Ant.ProveedorID= Req.ProveedorID
			INNER JOIN FACTURAPROV FPRO ON Req.ProveedorID = FPRO.ProveedorID AND Req.NoFactura = FPRO.NoFactura
			WHERE	LTRIM(RTRIM(Req.NoFactura))	<>''
			AND		Req.Estatus			= 'A'
			AND		Req.ClaveDispMov	= 0
			AND 	TipoDeposito		<> 'E'
			AND		IFNULL(Ant.AnticipoFactID,0)=0
			AND CASE
				WHEN Par_FechaConsulta <> Fecha_Vacia THEN
					FPRO.FechaFactura = Par_FechaConsulta 
				ELSE
					TRUE
            END;


	DECLARE CURSORDISREQGTO CURSOR FOR  /* CURSOR para Requisiciones Normales */
		SELECT	Req.DetReqGasID,	Req.NumReqGasID,	Req.TipoGastoID, 	Req.NoFactura,	Req.MontoAutorizado,
				Req.TipoDeposito,	Req.ProveedorID,	Pro.CuentaClave,
				CASE TipoPersona
						WHEN  PerFisica	THEN CONCAT(IFNULL(PrimerNombre,''), CASE WHEN char_length(IFNULL(trim(SegundoNombre),''))>0 THEN CONCAT(" ", trim(SegundoNombre)) ELSE '' END , CASE WHEN char_length(IFNULL(trim(ApellidoPaterno),''))>0 THEN CONCAT(" ", trim(ApellidoPaterno)) ELSE '' END,CASE WHEN char_length(IFNULL(trim(ApellidoMaterno),''))>0 THEN CONCAT(" ", trim(ApellidoMaterno)) ELSE '' END)
						WHEN  PerMoral	THEN RazonSocial
				END AS Proveedor,
				CASE Pro.TipoPersona
					WHEN  PerFisica	THEN RFC
					WHEN  PerMoral	THEN RFCpm
				END AS RFC
			FROM	REQGASTOSUCURMOV Req
				INNER JOIN PROVEEDORES	Pro ON Req.ProveedorID = Pro.ProveedorID
				INNER JOIN REQGASTOSUCUR RSU  ON RSU.NumReqGasID = Req.NumReqGasID
			WHERE 	Req.Estatus 		= 'A'
			AND 	Req.ClaveDispMov 	= 0
			AND 	Req.TipoDeposito 	<> 'E'
			AND 	ltrim(rtrim(Req.NoFactura))	= ''
			AND CASE
				WHEN Par_FechaConsulta <> Fecha_Vacia THEN
					RSU.FechRequisicion = Par_FechaConsulta
				ELSE
					TRUE
            END;

	DROP TABLE IF EXISTS TMPANTICIPOS;
	CREATE TEMPORARY TABLE TMPANTICIPOS
	SELECT 	MIN(Ant. AnticipoFactID) AS AnticipoFactID,	Ant.NoFactura,	Ant.ProveedorID
		FROM 	ANTICIPOFACTURA Ant
		WHERE  	EstatusAnticipo <> 'C'
		GROUP BY Ant.NoFactura,	Ant.ProveedorID;



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

	-- Tipo de deposito de la tabla REQGASTOSUCURMOV
	SET Efectivo			:= 'E';
	SET Cheque				:= 'C';
	SET Spei				:= 'S';
	SET BancaElec			:= 'B';
	SET TarjetaEmp			:= 'T';

	-- tipos de movimientos de la tabla TIPOSMOVTESO
	SET TipoSPEISinFac		:= '15'; 	-- Salida de Recursos SPEI por Pago a Provedores sin Factura
	SET TipoCheqSinFac   	:= '16';	-- Salida de Recursos Cheque por Pago a Provedores sin Factura
	SET TipoSPEIFac     	:= '5';		-- Salida de Recursos SPEI por Pago a Provedores Factura
	SET TipoCheqFac     	:= '6';		-- Salida de Recursos Cheque por Pago a Provedores Factura
	SET TipoBanESinFac		:= '17'; 	-- Salida de Recursos Banca Electronica por Pago a Provedores sin Factura
	SET TipoBanEFac 		:= '18'; 	-- Salida de Recursos Banca Electronica por Pago a Provedores Factura
	SET TipoTarESinFac   	:= '19';	-- Salida de Recursos Tarjeta Empresarial por Pago a Provedores sin Factura
	SET TipoTarEFac    		:= '20'; 	-- Salida de Recursos Tarjeta Empresarial por Pago a Provedores Factura
	SET Act_FolioDisper		:= 2;
	SET Var_FechaSistema 	:= (SELECT FechaSistema FROM PARAMETROSSIS);
	SET SiHabilita			:= "S";
	SET ValorParam			:= "HabilitaFechaDisp";
	SET Var_Control			:= 'folioOperacion';
    SET Fecha_Vacia 		:= '1900-01-01';
	ManejoErrores:BEGIN
		DECLARE EXIT HANDLER FOR SQLEXCEPTION
			BEGIN
				SET Par_NumErr = 999;
				SET Par_ErrMen = CONCAT('El SAFI ha tenido un problema al concretar la operacion. Disculpe las molestias que ',
										'esto le ocasiona. Ref: SP-DISPERSIONREGTOPRO');
			END;

		SELECT ValorParametro INTO Var_SiHabilita
			FROM PARAMGENERALES WHERE LlaveParametro=ValorParam;

		IF Var_SiHabilita=SiHabilita THEN
			SET Var_Fecha :=Par_Fecha;
		ELSE
			SET Var_Fecha :=Var_FechaSistema;
		END IF;


		-- se obtiene el numero de requisiciones autorizadas que cumplan con la condicion
		SET numeroReqAut :=(SELECT 	COUNT(Req.DetReqGasID)
								FROM 	REQGASTOSUCURMOV Req
								INNER JOIN REQGASTOSUCUR RSU  ON RSU.NumReqGasID = Req.NumReqGasID
								LEFT OUTER JOIN
								 (SELECT 	MIN(Ant. AnticipoFactID) AS AnticipoFactID,Ant.NoFactura, Ant.ProveedorID
										FROM ANTICIPOFACTURA Ant
										WHERE  EstatusAnticipo <> 'C'
										GROUP BY Ant.NoFactura, Ant.ProveedorID)	 AS Ant ON  Ant.NoFactura = Req.NoFactura
																	AND Ant.ProveedorID= Req.ProveedorID
								INNER JOIN FACTURAPROV FPRO ON Req.ProveedorID = FPRO.ProveedorID AND Req.NoFactura = FPRO.NoFactura
								WHERE	LTRIM(RTRIM(Req.NoFactura))	<>''
								AND  	Req.Estatus  		= 'A'
								AND 	Req.ClaveDispMov	= 0
								AND 	TipoDeposito 	<> 'E'
								AND 	Ant.AnticipoFactID IS NULL
								AND CASE
										WHEN Par_FechaConsulta <> Fecha_Vacia THEN
											FPRO.FechaFactura = Par_FechaConsulta
										ELSE
											TRUE
						            END);

		SET numeroReqAutSin	:= (SELECT 	COUNT(Req.DetReqGasID)
									FROM 	REQGASTOSUCURMOV Req
									INNER JOIN REQGASTOSUCUR RSU  ON RSU.NumReqGasID = Req.NumReqGasID
                                    INNER JOIN FACTURAPROV FPRO ON Req.ProveedorID = FPRO.ProveedorID AND Req.NoFactura = FPRO.NoFactura
									WHERE 	Req.Estatus		= 'A'
									AND 	ClaveDispMov 	= 0
									AND 	TipoDeposito 	<> 'E'
									AND 	LTRIM(RTRIM(Req.NoFactura))	= ''
									AND CASE
										WHEN Par_FechaConsulta <> Fecha_Vacia THEN
											FPRO.FechaFactura = Par_FechaConsulta 
										ELSE
											TRUE
						            END);

		-- Si el valor fuera nulo se  convierte a cero
		SET numeroReqAut 	:= IFNULL(numeroReqAut, Entero_Cero);
		SET numeroReqAutSin := IFNULL(numeroReqAutSin, Entero_Cero);

		IF(IFNULL(numeroReqAut,Entero_Cero) = Entero_Cero  AND IFNULL(numeroReqAutSin,Entero_Cero) = Entero_Cero )THEN
			SET Par_NumErr	:= 001;
			SET Par_ErrMen	:= 'No Hay Requisiciones Autorizadas para Importar';
			SET Var_Control	:= 'folioOperacion';
			LEAVE ManejoErrores;
		END IF;

		IF(IFNULL(Par_EmpresaID,Entero_Cero)) = Entero_Cero THEN
			SET Par_NumErr	:= 002;
			SET Par_ErrMen	:= 'La Empresa esta vacia';
			SET Var_Control	:= 'folioOperacion';
			LEAVE ManejoErrores;
		END IF;

		-- se valida que existe el numero de institucion
		SET Var_Institucion := IFNULL((SELECT InstitucionID
											FROM INSTITUCIONES
											WHERE InstitucionID	= Par_InstitucionID ),Entero_Cero);
		IF(IFNULL(Var_Institucion,Entero_Cero)) = Entero_Cero THEN
			SET Par_NumErr	:= 003;
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
			SET Par_NumErr	:= 004;
			SET Par_ErrMen	:= "La Cuenta Bancaria especificada no Existe";
			SET Var_Control	:= 'numCtaInstit';
			LEAVE ManejoErrores;
		END IF;


		SET Aud_FechaActual := CURRENT_TIMESTAMP();

		-- Si existen requisiciones autorizadas inserta el encabezado de la dispersion

		IF(IFNULL(numeroReqAut,Entero_Cero) > Entero_Cero  OR IFNULL(numeroReqAutSin,Entero_Cero) > Entero_Cero )THEN
			-- se inserta el encabezado de la dispersion.
			CALL DISPERSIONALT(
				Var_Fecha,			Var_Institucion,	Var_CtaInstitu,     Par_NumCtaInstit,		SalidaNo,
				Par_NumErr,			Par_ErrMen,			FolioOperac,        Par_EmpresaID,      	Aud_Usuario,
				Aud_FechaActual,	Aud_DireccionIP,    Aud_ProgramaID,     Aud_Sucursal,       	Aud_NumTransaccion);

			IF(Par_NumErr != Entero_Cero)THEN
				SET Par_NumErr	:= 004;
				SET Par_ErrMen	:= CONCAT("Error en generar el folio de Dispersion ", Par_ErrMen );
				SET Var_Control	:= 'folioOperacion';
				LEAVE ManejoErrores;
			END IF;

			-- SE ABRE EL CURSOR PARA LA REQUISIONES NORMALES
			OPEN CURSORDISREQGTO;
			BEGIN
				DECLARE EXIT HANDLER FOR SQLSTATE '02000' BEGIN END;
				CICLOREQGTO: LOOP
					FETCH CURSORDISREQGTO 	INTO
						Var_DetReqGasID,	Var_NumReqGasID,	Var_TipoGastoID,	Var_NoFactura,		Var_MontoAut,
						Var_TipoDeposito,	Var_ProveedorID,	Var_CuentaClave,	Var_ProveedorNom,	Var_RFC;

				-- se asigna el tipo de movimiento que corresponde para cada forma de pago
				CASE Var_TipoDeposito
					WHEN Cheque		THEN
						IF(IFNULL(Var_NoFactura,Cadena_Vacia) = Cadena_Vacia )THEN
							SET TipoMovDis := TipoCheqSinFac;
						ELSE
							SET TipoMovDis :=	TipoCheqFac;
						END IF;
						SET Var_FormaPago	:= FormaPagoCheque;
						SET Var_CuentaClave := Cadena_Vacia;
						SET Var_TipoChequera:= Cadena_Vacia;
					WHEN Spei		THEN
						IF(IFNULL(Var_NoFactura,Cadena_Vacia)) = Cadena_Vacia THEN
							SET TipoMovDis :=	TipoSPEISinFac;
						ELSE
							SET TipoMovDis :=	TipoSPEIFac;
						END IF;
						SET Var_FormaPago	:= FormaPagoSPEI;
						SET Var_TipoChequera:= Cadena_Vacia;
					WHEN BancaElec	THEN
						IF(IFNULL(Var_NoFactura,Cadena_Vacia)) = Cadena_Vacia THEN
							SET TipoMovDis :=	TipoBanESinFac;
						ELSE
							SET TipoMovDis :=	TipoBanEFac;
						END IF;
						SET Var_FormaPago	:= FormaPagoBanE;
						SET Var_CuentaClave := Cadena_Vacia;
						SET Var_TipoChequera:= Cadena_Vacia;
					WHEN TarjetaEmp	THEN
						IF(IFNULL(Var_NoFactura,Cadena_Vacia)) = Cadena_Vacia THEN
							SET TipoMovDis :=	TipoTarESinFac;
						ELSE
							SET TipoMovDis := TipoTarEFac;
						END IF;
						SET Var_FormaPago	:= FormaPagoTarE;
						SET Var_CuentaClave := Cadena_Vacia;
						SET Var_TipoChequera:= Cadena_Vacia;
				END CASE;
				SET Var_Descrip	:= CONCAT('PAGO PROVEEDOR ', Var_ProveedorNom);

				-- se valida si el numero de factura viene vacio, entonces la referencia sera el tipo de gasto
				IF(IFNULL(Var_NoFactura,Cadena_Vacia)) = Cadena_Vacia THEN
					SET Var_Referencia := Var_TipoGastoID;
					SET Var_FacturaProvID := Entero_Cero;
				ELSE
					SET Var_Referencia := Var_NoFactura;
					SET Var_FacturaProvID := (SELECT 	FacturaProvID
												FROM 	FACTURAPROV
												WHERE 	NoFactura = Var_NoFactura
												AND 	ProveedorID=Var_ProveedorID);

					SET Var_MontoAut	:= (SELECT 	TotalFactura
												FROM 	FACTURAPROV
												WHERE 	NoFactura = Var_NoFactura
												AND 	ProveedorID=Var_ProveedorID);
				END IF;

				-- se obtiene el numero de la sucursal de la requisicion
				SET Var_NumSucursal := (SELECT SucursalID FROM REQGASTOSUCUR WHERE NumReqGasID = Var_NumReqGasID);

				CALL DISPERSIONMOVALT(
					FolioOperac,			Entero_Cero,		Cadena_Vacia,		SUBSTRING(Var_Descrip,1,50),	Var_Referencia,
					TipoMovDis, 			Var_FormaPago,		Var_MontoAut, 		Var_CuentaClave,				Var_ProveedorNom,
					Var_Fecha,				Var_RFC,			EstatusPendien,		SalidaNo,						Var_NumSucursal,
					Entero_Cero,			Var_ProveedorID,	Var_FacturaProvID,	Var_DetReqGasID,				Var_TipoGastoID,
					Entero_Cero,			Cadena_Vacia,		Var_TipoChequera,	Par_NumErr,						Par_ErrMen,
					RegistroSalida,			Par_EmpresaID,		Aud_Usuario,		Aud_FechaActual,				Aud_DireccionIP,
					Aud_ProgramaID,			Aud_Sucursal,		Aud_NumTransaccion);

				IF(Par_NumErr > Entero_Cero)THEN
					SET Var_Control	:= 'folioOperacion';
					LEAVE ManejoErrores;
				END IF;

				-- Se actualiza el numero de folio de dispersion en la tabla de requisicion
				CALL REQGASTOSUCMOVACT(
					Var_DetReqGasID,		Entero_Cero,		Entero_Cero,		Cadena_Vacia,			Decimal_Cero,
					Entero_Cero,			Decimal_Cero,		Decimal_Cero,		Decimal_Cero,			Cadena_Vacia,
					Cadena_Vacia,			FolioOperac,		Entero_Cero,		Var_ProveedorID,		Act_FolioDisper,
					SalidaNo,				Par_NumErr,			Par_ErrMen,			Par_EmpresaID,			Aud_Usuario,
					Aud_FechaActual,		Aud_DireccionIP,	Aud_ProgramaID,		Aud_Sucursal, 			Aud_NumTransaccion);

				IF(Par_NumErr > Entero_Cero)THEN
					SET Var_Control	:= 'folioOperacion';
					LEAVE ManejoErrores;
				END IF;

				END LOOP CICLOREQGTO;
			END;
			CLOSE CURSORDISREQGTO;


			-- ***********  inicio CURSOR para Facturas *********
			OPEN CURSORDISREQGTOFAC;
			BEGIN
				DECLARE EXIT HANDLER FOR SQLSTATE '02000' BEGIN END;
				CICLOREQGTOFAC: LOOP
					FETCH CURSORDISREQGTOFAC 	INTO
						Var_DetReqGasID,	Var_NumReqGasID,		Var_TipoGastoID,		Var_NoFactura,	Var_MontoAut,
						Var_TipoDeposito,	Var_ProveedorID;


					-- se obtienen los valores que se ocupan de proveedores
					SET Var_ProveedorNom := (SELECT	CASE TipoPersona
																WHEN  PerFisica	THEN CONCAT(IFNULL(PrimerNombre,''),CASE WHEN char_length(IFNULL(trim(SegundoNombre),''))>0 THEN CONCAT(" ", trim(SegundoNombre)) ELSE '' END , CASE WHEN char_length(IFNULL(trim(ApellidoPaterno),''))>0 THEN CONCAT(" ", trim(ApellidoPaterno)) ELSE '' END,CASE WHEN char_length(IFNULL(trim(ApellidoMaterno),''))>0 THEN CONCAT(" ", trim(ApellidoMaterno)) ELSE '' END)
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
					SET Var_CuentaClave := (SELECT	CuentaClave
												FROM PROVEEDORES
												WHERE ProveedorID = Var_ProveedorID);

				-- se asigna el tipo de movimiento que corresponde para cada forma de pago
				CASE Var_TipoDeposito
					WHEN Cheque		THEN
						IF(IFNULL(Var_NoFactura,Cadena_Vacia)) = Cadena_Vacia THEN
							SET TipoMovDis := TipoCheqSinFac;
						ELSE
							SET TipoMovDis :=	TipoCheqFac;
						END IF;
						SET Var_FormaPago	:= FormaPagoCheque;
						SET Var_CuentaClave := Cadena_Vacia;
						SET Var_TipoChequera:= Cadena_Vacia;
					WHEN Spei		THEN
						IF(IFNULL(Var_NoFactura,Cadena_Vacia)) = Cadena_Vacia THEN
							SET TipoMovDis :=	TipoSPEISinFac;
						ELSE
							SET TipoMovDis :=	TipoSPEIFac;
						END IF;
						SET Var_FormaPago	:= FormaPagoSPEI;
						SET Var_TipoChequera:= Cadena_Vacia;
					WHEN BancaElec	THEN
						IF(IFNULL(Var_NoFactura,Cadena_Vacia)) = Cadena_Vacia THEN
							SET TipoMovDis :=	TipoBanESinFac;
						ELSE
							SET TipoMovDis :=	TipoBanEFac;
						END IF;
						SET Var_FormaPago	:= FormaPagoBanE;
						SET Var_CuentaClave := Cadena_Vacia;
						SET Var_TipoChequera:= Cadena_Vacia;
					WHEN TarjetaEmp	THEN
						IF(IFNULL(Var_NoFactura,Cadena_Vacia)) = Cadena_Vacia THEN
							SET TipoMovDis :=	TipoTarESinFac;
						ELSE
							SET TipoMovDis := TipoTarEFac;
						END IF;
						SET Var_FormaPago	:= FormaPagoTarE;
						SET Var_CuentaClave := Cadena_Vacia;
						SET Var_TipoChequera:= Cadena_Vacia;
				END CASE;
				SET Var_Descrip	:= CONCAT('PAGO PROVEEDOR ', Var_ProveedorNom);

				-- se valida si el numero de factura viene vacio, entonces la referencia sera el tipo de gasto
				IF(IFNULL(Var_NoFactura,Cadena_Vacia)) = Cadena_Vacia THEN
					SET Var_Referencia := Var_TipoGastoID;
					SET Var_FacturaProvID := Entero_Cero;
				ELSE
					SET Var_Referencia := Var_NoFactura;
					SET Var_FacturaProvID := (SELECT 	FacturaProvID
												FROM 	FACTURAPROV
												WHERE 	NoFactura = Var_NoFactura
												AND 	ProveedorID=Var_ProveedorID);

					SET Var_MontoAut	:= (SELECT 	TotalFactura
												FROM 	FACTURAPROV
												WHERE 	NoFactura = Var_NoFactura
												AND 	ProveedorID=Var_ProveedorID);
				END IF;

				-- se obtiene el numero de la sucursal de la requisicion
				SET Var_NumSucursal := (SELECT SucursalID FROM REQGASTOSUCUR WHERE NumReqGasID = Var_NumReqGasID);

				CALL DISPERSIONMOVALT(
					FolioOperac,			Entero_Cero,		Cadena_Vacia,		SUBSTRING(Var_Descrip,1,50),	Var_Referencia,
					TipoMovDis, 			Var_FormaPago,		Var_MontoAut, 		Var_CuentaClave,				Var_ProveedorNom,
					Var_Fecha,				Var_RFC,			EstatusPendien,		SalidaNo,						Var_NumSucursal,
					Entero_Cero,			Var_ProveedorID,	Var_FacturaProvID,	Var_DetReqGasID,				Var_TipoGastoID,
					Entero_Cero,			Cadena_Vacia,		Var_TipoChequera,	Par_NumErr,						Par_ErrMen,
					RegistroSalida,			Par_EmpresaID,		Aud_Usuario,		Aud_FechaActual,				Aud_DireccionIP,
					Aud_ProgramaID,			Aud_Sucursal, 		Aud_NumTransaccion);
				IF(Par_NumErr > Entero_Cero)THEN
					SET Var_Control	:= 'folioOperacion';
					LEAVE ManejoErrores;
				END IF;


				-- Se actualiza el numero de folio de dispersion en la tabla de requisicion
				CALL REQGASTOSUCMOVACT(
					Var_DetReqGasID,		Entero_Cero,		Entero_Cero,		Cadena_Vacia,			Decimal_Cero,
					Entero_Cero,			Decimal_Cero,		Decimal_Cero,		Decimal_Cero,			Cadena_Vacia,
					Cadena_Vacia,			FolioOperac,		Entero_Cero,		Var_ProveedorID,		Act_FolioDisper,
					SalidaNo,				Par_NumErr,			Par_ErrMen,			Par_EmpresaID,			Aud_Usuario,
					Aud_FechaActual,		Aud_DireccionIP,	Aud_ProgramaID,		Aud_Sucursal, 			Aud_NumTransaccion);

				IF(Par_NumErr > Entero_Cero)THEN
					SET Var_Control	:= 'folioOperacion';
					LEAVE ManejoErrores;
				END IF;

				END LOOP CICLOREQGTOFAC;
			END;
			CLOSE CURSORDISREQGTOFAC;

			/* Innicio del ciclo del cursos par actualizar cada una de las requisiciones
			de tipo factura que fueron dispersadas	*/

			OPEN CURSORACTUALIZAFAC;
			BEGIN
				DECLARE EXIT HANDLER FOR SQLSTATE '02000' BEGIN END;
				CICLOREQGTOFACTURA: LOOP

					FETCH CURSORACTUALIZAFAC 	INTO
						Var_DetReqGasID,	Var_NumReqGasID,		Var_TipoGastoID,		Var_NoFactura,	Var_MontoAut,
						Var_TipoDeposito,	Var_ProveedorID;


			-- Se actualiza el numero de folio de dispersion en la tabla de requisicion
			-- esta vez par a cada folio de requisicion de tipo Factura
				CALL REQGASTOSUCMOVACT(
					Var_DetReqGasID,		Entero_Cero,		Entero_Cero,		Cadena_Vacia,			Decimal_Cero,
					Entero_Cero,			Decimal_Cero,		Decimal_Cero,		Decimal_Cero,			Cadena_Vacia,
					Cadena_Vacia,			FolioOperac,		Entero_Cero,		Var_ProveedorID,		Act_FolioDisper,
					SalidaNo,				Par_NumErr,			Par_ErrMen,			Par_EmpresaID,			Aud_Usuario,
					Aud_FechaActual,		Aud_DireccionIP,	Aud_ProgramaID,		Aud_Sucursal, 			Aud_NumTransaccion);
				IF(Par_NumErr > Entero_Cero)THEN
					SET Var_Control	:= 'folioOperacion';
					LEAVE ManejoErrores;
				END IF;

				END LOOP CICLOREQGTOFACTURA;
			END;
			CLOSE CURSORACTUALIZAFAC;

		END IF;

	SET Par_NumErr = 0;
	SET Par_ErrMen = CONCAT("Dispersion agregada Exitosamente: ",CONVERT(FolioOperac, CHAR(10)) );

	END ManejoErrores;

	IF(Par_Salida = SalidaSi) THEN
		SELECT	Par_NumErr	AS NumErr,
				Par_ErrMen	AS ErrMen,
		'folioOperacion' AS control,
		FolioOperac AS consecutivo;
	END IF;

END TerminaStore$$