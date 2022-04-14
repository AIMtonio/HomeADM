-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- CAJASCHEQUERAALT
DELIMITER ;
DROP PROCEDURE IF EXISTS `CAJASCHEQUERAALT`;DELIMITER $$

CREATE PROCEDURE `CAJASCHEQUERAALT`(
# =============================================================
# -------- SP PARA DAR DE ALTA UNA ASIGNACION DE CHEQUERA------
# =============================================================
	Par_InstitucionID		INT(11),		-- Numero de la Institucion Bancaria
	Par_NumCtaInstit		VARCHAR(20),	-- Numero de la cuenta institucional bancaria
	Par_SucursalID			INT(11),		-- Numero de la sucursal a quien se le hara la asignacion
	Par_CajaID				INT(11),		-- Numero de la caja a quien se le hara la asignacion
    Par_FolioCheqInicial	INT(11),		-- Numero de Folio Inicial del "bloque" de cheques

    Par_FolioCheqFinal		INT(11),		-- Numero de Folio Final del "bloque" de cheques
	Par_Estatus				CHAR(1),		-- Estatus de la Chequera A.- Asignada D.- Desasignada
    Par_TipoChequera		CHAR(2),		-- Tipo de chequera E.- Estandar P.- Proforma
    Par_FolioUtilizar		BIGINT(20),		-- Folio del ultimo cheque que se utilizo dentro del rango

	Par_Salida				CHAR(1),		-- Salida del sp S.- Si N.- No
	INOUT Par_NumErr		INT(11),		-- Numero de Error
	INOUT Par_ErrMen		VARCHAR(400),	-- Mensaje de Error

	Aud_EmpresaID			INT(11),
	Aud_Usuario				INT(11),
	Aud_FechaActual			DATETIME,
	Aud_DireccionIP			VARCHAR(15),
	Aud_ProgramaID			VARCHAR(50),
	Aud_Sucursal			INT(11),
	Aud_NumTransaccion		BIGINT(20)
)
TerminaStore: BEGIN

	-- Declaracion de constantes
	DECLARE Fecha_Vacia 		DATE;
	DECLARE Cadena_Vacia		CHAR(1);
	DECLARE Entero_Cero			INT(1);
	DECLARE SalidaSI			CHAR(1);
	DECLARE EstatusAsignada		CHAR(1);

	-- Declaracion de variables
	DECLARE Var_FechaActualiz	DATETIME;
	DECLARE Var_DescripcionCaja	CHAR(100);
	DECLARE Var_TipoCaja		CHAR(100);
	DECLARE Var_Consecutivo		INT(11);
	DECLARE Var_EstatusOrig		CHAR(1);
	DECLARE Var_Control			CHAR(100);
	DECLARE Var_CuentaAhoID		BIGINT(12);
	DECLARE Var_CajaID			INT(11);

	-- Asignacion de constantes
	SET Fecha_Vacia				:= '1900-01-01';	-- Fecha Vacia
	SET Cadena_Vacia			:= '';				-- Cadena o String Vacio
	SET Entero_Cero				:= 0;				-- Entero Cero
	SET SalidaSI				:= 'S';				-- Salida si
	SET EstatusAsignada			:= 'A';				-- Estatus de Chequera Asignada

	-- Asignacion de variables
	SET Var_Consecutivo			:= 0;

	ManejoErrores: BEGIN -- Inicio del Manejo de Errores

		DECLARE EXIT HANDLER FOR SQLEXCEPTION BEGIN
			SET Par_NumErr = 999;
			SET Par_ErrMen = CONCAT('El SAFI ha tenido un problema al concretar la operacion. ',
								    'Disculpe las molestias que esto le ocasiona. Ref: SP-CAJASCHEQUERAALT');
			SET Var_Control= 'SQLEXCEPTION' ;
		END;

		IF(IFNULL(Par_InstitucionID,Entero_Cero) = Entero_Cero) THEN
			SET Par_NumErr		:= 001;
			SET Par_ErrMen 		:= 'El Numero de la Institucion Viene Vacio.';
			SET Var_Control 	:= 'institucionID';
			SET Var_Consecutivo := Entero_Cero;
			LEAVE ManejoErrores;
		END IF;

		IF(IFNULL(Par_SucursalID,Entero_Cero) = Entero_Cero) THEN
			SET Par_NumErr 		:= 002;
			SET Par_ErrMen 		:= 'El Numero de la Sucursal Viene Vacio.';
			SET Var_Control 	:= 'sucursalID';
			SET Var_Consecutivo := Entero_Cero;
			LEAVE ManejoErrores;
		END IF;

		IF(IFNULL(Par_CajaID,Entero_Cero) = Entero_Cero) THEN
			SET Par_NumErr 		:= 003;
			SET Par_ErrMen 		:= 'El Numero de la Caja Viene Vacio.';
			SET Var_Control 	:= 'cajaID';
			SET Var_Consecutivo := Entero_Cero;
			LEAVE ManejoErrores;
		END IF;

		IF(IFNULL(Par_NumCtaInstit,Entero_Cero) = Entero_Cero) THEN
			SET Par_NumErr 		:= 004;
			SET Par_ErrMen 		:= 'El Numero de la Cuenta Institucional viene Vacio.';
			SET Var_Control 	:= 'numCtaInstit';
			SET Var_Consecutivo := Entero_Cero;
			LEAVE ManejoErrores;
		END IF;

		IF(IFNULL(Par_FolioCheqInicial,Entero_Cero) = Entero_Cero) THEN
			SET Par_NumErr 		:= 005;
			SET Par_ErrMen 		:= 'El Numero del Folio Inicial viene Vacio.';
			SET Var_Control 	:= 'folioInicial';
			SET Var_Consecutivo := Entero_Cero;
			LEAVE ManejoErrores;
		END IF;

		IF(IFNULL(Par_FolioCheqFinal,Entero_Cero) = Entero_Cero) THEN
			SET Par_NumErr 		:= 006;
			SET Par_ErrMen 		:= 'El Numero del Folio Final viene Vacio.';
			SET Var_Control 	:= 'folioFinal';
			SET Var_Consecutivo := Entero_Cero;
			LEAVE ManejoErrores;
		END IF;

		SELECT 		CA.CuentaAhoID INTO Var_CuentaAhoID
			FROM 	CUENTASAHOTESO CA
			WHERE 	CA.NumCtaInstit		= Par_NumCtaInstit
			AND 	CA.InstitucionID	= Par_InstitucionID;

		IF(IFNULL(Var_CuentaAhoID,Entero_Cero) = Entero_Cero) THEN
			SET Par_NumErr 		:= 007;
			SET Par_ErrMen 		:= 'El Numero de la Cuenta de Ahorro no Existe.';
			SET Var_Control 	:= 'numCtaInstit';
			SET Var_Consecutivo := Entero_Cero;
			LEAVE ManejoErrores;
		END IF;

		SELECT 		CajaID,		DescripcionCaja,		TipoCaja
					INTO 	Var_CajaID,	Var_DescripcionCaja,	Var_TipoCaja
			FROM 	CAJASVENTANILLA
			WHERE 	SucursalID	= Par_SucursalID
			AND 	CajaID		= Par_CajaID;

		IF(IFNULL(Var_CajaID,Entero_Cero) = Entero_Cero) THEN
			SET Par_NumErr 		:= 008;
			SET Par_ErrMen 		:= 'La Caja No Pertenece a la Sucursal.';
			SET Var_Control 	:= 'numCtaInstit';
			SET Var_Consecutivo := Entero_Cero;
			LEAVE ManejoErrores;
		END IF;

		IF(IFNULL(Par_TipoChequera, Cadena_Vacia)) = Cadena_Vacia THEN
			SET Par_NumErr      := 09;
			SET Par_ErrMen      := 'El tipo de Chequera esta Vacia.';
			SET Var_Control		:= 'tipoChequera';
			SET Var_Consecutivo := Entero_Cero;
			LEAVE ManejoErrores;
		END IF;

		SET Aud_FechaActual 	:= CURRENT_TIMESTAMP();
		SET Var_FechaActualiz 	:= (SELECT CONVERT(CONCAT(FechaSistema,' ',CURTIME()), DATETIME) FROM PARAMETROSSIS);

		-- Llamada al sp para asignar un consecutivo a la tabla
		CALL FOLIOSAPLICAACT('CAJASCHEQUESMOVS', Var_Consecutivo);

		INSERT INTO CAJASCHEQUERA(
			SucursalID,				CajaID,				InstitucionID,			NumCtaInstit,		CuentaAhoID,
			DescripcionCaja,		TipoCaja,			FolioCheqInicial,		FolioCheqFinal,		FolioUtilizar,
			Estatus,		        FechaActEstatus,	TipoChequera,			EmpresaID,			Usuario,
			FechaActual,			DireccionIP,	    ProgramaID,				Sucursal,			NumTransaccion)
		VALUES (
			Par_SucursalID,			Par_CajaID,			Par_InstitucionID,		Par_NumCtaInstit,	Var_CuentaAhoID,
			Var_DescripcionCaja,	Var_TipoCaja,		Par_FolioCheqInicial,	Par_FolioCheqFinal,	CASE WHEN IFNULL(Par_FolioUtilizar,Entero_Cero) = Entero_Cero THEN
																											(Par_FolioCheqInicial-1)ELSE Par_FolioUtilizar END,
			Par_Estatus,		    Var_FechaActualiz,	Par_TipoChequera,		Aud_EmpresaID,		Aud_Usuario,
			Aud_FechaActual,		Aud_DireccionIP,	Aud_ProgramaID,			Aud_Sucursal,		Aud_NumTransaccion);

		SET Par_NumErr  := 000;
		SET Par_ErrMen  := CONCAT('Chequeras Asignadas Exitosamente: ',Par_CajaID );
		SET Var_Control := 'institucionID';

	END ManejoErrores; -- Fin del Manejo de Errores

	IF (Par_Salida = SalidaSI) THEN
			SELECT  Par_NumErr 		AS NumErr,
					Par_ErrMen 		AS ErrMen,
					Var_Control 	AS control,
					Var_Consecutivo	AS consecutivo;
	END IF;

END TerminaStore$$