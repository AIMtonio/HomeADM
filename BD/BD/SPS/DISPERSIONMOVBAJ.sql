-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- DISPERSIONMOVBAJ
DELIMITER ;
DROP PROCEDURE IF EXISTS `DISPERSIONMOVBAJ`;
DELIMITER $$

-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- DISPERSIONMOVBAJ
DELIMITER ;
DROP PROCEDURE IF EXISTS `DISPERSIONMOVBAJ`;
DELIMITER $$

CREATE PROCEDURE `DISPERSIONMOVBAJ`(
/*SP QUE SE REALIZA BAJA DE DISPERSION*/
	Par_ClaveDispMov		INT(11),
	Par_DispersionID		INT(11),

	Par_Salida				CHAR(1),
	inout	Par_NumErr		INT(11),
	inout	Par_ErrMen		VARCHAR(100),

	Aud_EmpresaID			INT(11),
	Aud_Usuario				INT(11),
	Aud_FechaActual			DATETIME,
	Aud_DireccionIP			VARCHAR(15),
	Aud_ProgramaID			VARCHAR(50),
	Aud_Sucursal			INT(11),
	Aud_NumTransaccion		BIGINT(20)
	)
TerminaStore: BEGIN

	-- Declaracion de Variables
	DECLARE Var_Control		VARCHAR(50);
	DECLARE Var_Consecutivo	VARCHAR(50);
	DECLARE Var_FechaSis	DATE;

	-- Declaracion de Constantes
	DECLARE Cadena_Vacia	CHAR(1);
	DECLARE Fecha_Vacia		DATE;
	DECLARE Entero_Cero		INT;
	DECLARE Salida_Si  		CHAR(1);

	-- Asignacion de Constantes
	SET Cadena_Vacia	:= '';
	SET Fecha_Vacia		:= '1900-01-01';
	SET Entero_Cero		:= 0;
	SET Salida_Si		:= 'S';

	ManejoErrores: BEGIN
		DECLARE EXIT HANDLER FOR SQLEXCEPTION BEGIN
			SET Par_NumErr := 999;
			SET Par_ErrMen := CONCAT('El SAFI ha tenido un problema al concretar la operacion. Disculpe las molestias que ',
										'esto le ocasiona. Ref: SP-DISPERSIONCANPRO');
			SET Var_Control := 'sqlException' ;
		END;

	SET Var_FechaSis := (SELECT FechaSistema FROM PARAMETROSSIS);

	INSERT INTO HISDISPERSIONMOV(
		NumeroTrans,			FechaCancela,		ClaveDispMov,			DispersionID,		CuentaCargo,
		CuentaContable,			Descripcion,		Referencia,				TipoMovDIspID,		FormaPago,
		Monto,					CuentaDestino,		Identificacion,			Estatus,			NombreBenefi,
		FechaEnvio,				SucursalID,			CreditoID,				ProveedorID,		FacturaProvID,
		DetReqGasID,			TipoGastoID,		CatalogoServID,			AnticipoFact,		TipoChequera,
		ConceptoDispersion,		EmpresaID,			Usuario, 				FechaActual, 		DireccionIP,
		ProgramaID,				Sucursal,			NumTransaccion)
		SELECT
		Aud_NumTransaccion,		Var_FechaSis,		MOV.ClaveDispMov,		MOV.DispersionID,	MOV.CuentaCargo,
		MOV.CuentaContable,		MOV.Descripcion,	MOV.Referencia,			MOV.TipoMovDIspID,	MOV.FormaPago,
		MOV.Monto,				MOV.CuentaDestino,	MOV.Identificacion,		MOV.Estatus,		MOV.NombreBenefi,
		MOV.FechaEnvio,			MOV.SucursalID,		MOV.CreditoID,			MOV.ProveedorID,	MOV.FacturaProvID,
		MOV.DetReqGasID,		MOV.TipoGastoID,	MOV.CatalogoServID,		MOV.AnticipoFact,	MOV.TipoChequera,
		MOV.ConceptoDispersion,	MOV.EmpresaID,		MOV.Usuario, 			MOV.FechaActual, 	MOV.DireccionIP,
		MOV.ProgramaID,			MOV.Sucursal,		MOV.NumTransaccion
		FROM
			DISPERSIONMOV AS MOV
			WHERE
			MOV.ClaveDispMov = Par_ClaveDispMov
			AND MOV.DispersionID = Par_DispersionID;


		DELETE
			FROM DISPERSIONMOV
			WHERE ClaveDispMov = Par_ClaveDispMov
			AND DispersionID = Par_DispersionID;

		SET Par_NumErr 		:= 0;
		SET Par_ErrMen 		:= 'Movimiento de Dispersión Eliminado';
	END ManejoErrores;

	IF (Par_Salida = Salida_SI) THEN
		SELECT CONVERT(Par_NumErr, CHAR(3)) AS NumErr,
			Par_ErrMen	 AS ErrMen,
			Var_Control AS Control,
			Var_Consecutivo AS Consecutivo;
	END IF;
END TerminaStore$$