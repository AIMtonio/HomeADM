-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- DISPERSIONPASERPRO
DELIMITER ;
DROP PROCEDURE IF EXISTS `DISPERSIONPASERPRO`;DELIMITER $$

CREATE PROCEDURE `DISPERSIONPASERPRO`(
# ==========================================================================
# ---- SP PARA IMPORTAR LOS PAGOS DE SERVICIOS QUE SEAN PAGO AUTOMATICO-----
# ==========================================================================
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
	DECLARE Cadena_Vacia		CHAR(1);
	DECLARE Entero_Cero			INT;
	DECLARE Decimal_Cero		DECIMAL(12,4);
	DECLARE SalidaSi			CHAR(1);
	DECLARE SalidaNo			CHAR(1);
	DECLARE Est_Pendiente		CHAR(1);
	DECLARE FormaPagoSPEI		INT(11);
	DECLARE Act_FolioDis		INT(11);		-- indica el numero de actualizacion que se hara para los movimientos de req.
	DECLARE Var_NO				CHAR(1);		-- Variable NO
	DECLARE TipoMovDisSpei		CHAR(4);

	-- Declaracion de Variables
	DECLARE Var_NumSucursal		INT(11);
	DECLARE Var_Institucion		INT(11);
	DECLARE Var_CtaInstitu		VARCHAR(20);
	DECLARE FolioOperac			INT(11);
	DECLARE Var_NumPagoServ		INT(11);		-- variable para saber si existen o no pagos de sevicios no tomados en cuenta
	DECLARE Var_FechaSistema 	DATE;
	DECLARE Var_Referencia		VARCHAR(50);
	DECLARE Var_SegRefere		VARCHAR(50);	-- Segunda Referencia
	DECLARE Var_MontoOpe		DECIMAL(12,2);
	DECLARE Var_CatalogoServID	INT(11);
	DECLARE Var_ProveedorNom	VARCHAR(200);
	DECLARE Var_CuentaClabe		VARCHAR(18);
	DECLARE RegistroSalida		INT(11);
	DECLARE Var_Descripcion		VARCHAR(200);
	DECLARE Var_Fecha			DATE;
	DECLARE Fecha				DATE;
	DECLARE SiHabilita			CHAR(1);
	DECLARE ValorParam			VARCHAR(100);
	DECLARE Var_SiHabilita		CHAR(1);
	DECLARE Var_Control			VARCHAR(100);
    DECLARE Var_TipoChequera	CHAR(2);

	-- Declaracion de cursor
	DECLARE CURSORPAGOSERVICIOS CURSOR FOR  /* Cursor para Pago de servicios no aplicados ni importados*/
		SELECT 	Cat.CatalogoServID, 	MAX(Pag.SucursalID),		SUM(Pag.MontoServicio),		MAX(Cat.CuentaClabe),	 SUBSTRING(MAX(Cat.RazonSocial),1,70),
				MAX(Pag.Fecha)
			FROM 	PAGOSERVICIOS	Pag,
					CATALOGOSERV	Cat
			WHERE	IFNULL(Pag.FolioDispersion,Entero_Cero) 	= Entero_Cero
			 AND	IFNULL(Pag.Aplicado,Var_NO)					= Var_NO
			 AND 	Pag.CatalogoServID							= Cat.CatalogoServID
			 AND	IFNULL(Cat.PagoAutomatico,Var_NO)			= 'S'
			GROUP BY Cat.CatalogoServID;

	-- Asignacion de Constantes
	SET Entero_Cero			:= 0;
	SET Decimal_Cero		:= 0.0;
	SET Cadena_Vacia		:= '';
	SET SalidaSi			:= 'S';
	SET SalidaNo			:= 'N';
	SET Est_Pendiente		:= 'P';		-- Estatus Pendiente
	SET FormaPagoSPEI		:= 1;
	SET Var_NO				:= 'N';
	SET Act_FolioDis		:= 1;		-- para actualizar campo folio dispersion cuando se importa el registro
	SET TipoMovDisSpei		:= 21;	 	-- Tipo de movimiento SPEI por pago de servicios - tabla TIPOSMOVTESO

	-- Asignacion de variables
	SET Var_Descripcion 	:= 'PAGO DE SERVICIOS-';
	SET Var_FechaSistema	:= (SELECT FechaSistema FROM PARAMETROSSIS);
	SET SiHabilita			:="S";
	SET ValorParam			:="HabilitaFechaDisp";

	ManejoErrores:BEGIN

		DECLARE EXIT HANDLER FOR SQLEXCEPTION
			BEGIN
				SET Par_NumErr = 999;
				SET Par_ErrMen = CONCAT('El SAFI ha tenido un problema al concretar la operacion. Disculpe las molestias que ',
										'esto le ocasiona. Ref: SP-DISPERSIONPASERPRO');
			END;

		SELECT ValorParametro INTO Var_SiHabilita
			FROM 	PARAMGENERALES
            WHERE 	LlaveParametro	= ValorParam;

		IF Var_SiHabilita=SiHabilita THEN
			SET Fecha :=Par_Fecha;
		ELSE
			SET Fecha :=Var_FechaSistema;
		END IF;

		-- se obtiene el numero de pagos de servicios que aun no se han aplicado ni tomado en cuenta
		SET Var_NumPagoServ :=(SELECT 	COUNT(PagoServicioID)
								 FROM	PAGOSERVICIOS Pag,
										CATALOGOSERV	Cat
								WHERE	IFNULL(Pag.FolioDispersion,Entero_Cero) 	= Entero_Cero
								AND		IFNULL(Pag.Aplicado,Var_NO)					= Var_NO
								AND 	Pag.CatalogoServID							= Cat.CatalogoServID
								AND		IFNULL(Cat.PagoAutomatico,Var_NO)			= 'S');

		-- Si el valor fuera nulo se  convierte a cero
		SET Var_NumPagoServ := IFNULL(Var_NumPagoServ, Entero_Cero);
		IF(IFNULL(Var_NumPagoServ,Entero_Cero)) = Entero_Cero THEN
			SET Par_NumErr	:= 001;
			SET Par_ErrMen	:= 'No Hay Pagos de Servicios Pendientes por Importar';
			SET Var_Control	:= 'folioOperacion';
			LEAVE ManejoErrores;
		END IF;

		IF(IFNULL(Par_EmpresaID,Entero_Cero)) = Entero_Cero THEN
			SET Par_NumErr	:= 001;
			SET Par_ErrMen	:= 'La Empresa esta vacia';
			SET Var_Control	:= '';
			LEAVE ManejoErrores;
		END IF;

		-- se valida que exixte el numero de institucion
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
										WHERE	InstitucionID	= Par_InstitucionID
										AND		NumCtaInstit	= Par_NumCtaInstit),Cadena_Vacia);

		IF(IFNULL(Var_CtaInstitu,Cadena_Vacia)) = Cadena_Vacia THEN
			SET Par_NumErr	:= 002;
			SET Par_ErrMen	:= 'La Cuenta Bancaria especificada no Existe';
			SET Var_Control	:= 'numCtaInstit';
			LEAVE ManejoErrores;
		END IF;

		SET Aud_FechaActual := CURRENT_TIMESTAMP();

		-- Si existen pagos de servicios pendientes por aplicar se inserta el encabezado de la dispersion
		IF ( IFNULL(Var_NumPagoServ,Entero_Cero) > Entero_Cero) THEN
			-- se inserta el encabezado de la dispersion.
			CALL DISPERSIONALT(
				Fecha,				Var_Institucion,    Var_CtaInstitu,     Par_NumCtaInstit,		SalidaNo,
				Par_NumErr, 		Par_ErrMen,			FolioOperac,        Par_EmpresaID,      	Aud_Usuario,
				Aud_FechaActual,	Aud_DireccionIP,    Aud_ProgramaID,     Aud_Sucursal,       	Aud_NumTransaccion);

			IF(Par_NumErr != Entero_Cero)THEN
				SET Par_NumErr 	:= 1;
				SET Par_ErrMen 	:= 'Error al generar folio de Dispersion';
				SET Var_Control	:= '';
				LEAVE ManejoErrores;
			END IF;

			OPEN CURSORPAGOSERVICIOS;
			BEGIN
				DECLARE EXIT HANDLER FOR SQLSTATE '02000' BEGIN END;
				CICLO:LOOP
					FETCH CURSORPAGOSERVICIOS 	INTO
						Var_CatalogoServID,	Var_NumSucursal,	Var_MontoOpe,		Var_CuentaClabe,	Var_ProveedorNom,
						Var_Fecha;

				SET Var_Descripcion 	:= CONCAT(Var_Descripcion,Var_ProveedorNom,'-DEL DIA: ',Var_Fecha);

				SET Var_Descripcion 	:= SUBSTRING(Var_Descripcion,1,50);

				SET Var_Referencia		:= IFNULL(Aud_NumTransaccion, Entero_Cero);
				SET Var_TipoChequera	:= Cadena_Vacia;
				CALL DISPERSIONMOVALT(
					FolioOperac,			Entero_Cero,		Cadena_Vacia,		Var_Descripcion,		Var_Referencia,
					TipoMovDisSpei, 		FormaPagoSPEI,		Var_MontoOpe, 		Var_CuentaClabe,		Var_ProveedorNom,
					Fecha,					Cadena_Vacia,		Est_Pendiente,		SalidaNo,				Var_NumSucursal,
					Entero_Cero,			Entero_Cero,		Entero_Cero,		Entero_Cero,			Entero_Cero,
					Var_CatalogoServID,		Cadena_Vacia,		Var_TipoChequera,	Par_NumErr,				Par_ErrMen,
                    RegistroSalida,			Par_EmpresaID,		Aud_Usuario,		Aud_FechaActual,		Aud_DireccionIP,
                    Aud_ProgramaID,			Aud_Sucursal,		Aud_NumTransaccion);

				IF(Par_NumErr != Entero_Cero) THEN /* si sucedio un error se sale del ciclo */
					LEAVE CICLO;
				ELSE
					SET Par_NumErr	:= 0;
				END IF;

				-- Se actualiza el numero de folio de dispersion en la tabla de pagos de servicios
				CALL PAGOSERVICIOSACT(
					Var_CatalogoServID,		FolioOperac,		Cadena_Vacia,		Act_FolioDis,	SalidaNo,
					Par_NumErr,				Par_ErrMen,			Par_EmpresaID,		Aud_Usuario,	Aud_FechaActual,
					Aud_DireccionIP,		Aud_ProgramaID,		Aud_Sucursal,		Aud_NumTransaccion
				);

				END LOOP CICLO;
			END;
			CLOSE CURSORPAGOSERVICIOS;

			IF(Par_NumErr = Entero_Cero) THEN /* si sucedio un error se sale del sp */
				SET Par_NumErr	:= 0;
			ELSE
				SET Par_NumErr 	:= Par_NumErr;
				SET Par_ErrMen 	:= Par_ErrMen;
				SET Var_Control	:= 'creditoFondeoID';
				LEAVE ManejoErrores;
			END IF;
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