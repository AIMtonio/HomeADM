

-- APORTCONSOLIDADASBAJ --

DELIMITER ;
DROP PROCEDURE IF EXISTS `APORTCONSOLIDADASBAJ`;
-- --------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- --------------------------------------------------------------------------------
DELIMITER $$
CREATE PROCEDURE `APORTCONSOLIDADASBAJ`(
/* SP DE BAJA DE APORTACIONES CONSOLIDADAS */
	Par_AportacionID			INT(11),		-- ID de Aportación.
	Par_TipoBaja				INT(11),		-- Tipo de Baja.
	Par_Salida					CHAR(1),		-- Indica el tipo de salida S.- Si N.- No
	INOUT Par_NumErr			INT(11),		-- Numero de Error
	INOUT Par_ErrMen			VARCHAR(400),	-- Mensaje de Error

	/* Parametros de Auditoria */
	Par_EmpresaID				INT(11),
	Aud_Usuario					INT(11),
	Aud_FechaActual				DATETIME,
	Aud_DireccionIP				VARCHAR(15),
	Aud_ProgramaID				VARCHAR(50),

	Aud_Sucursal				INT(11),
	Aud_NumTransaccion			BIGINT(20)
)
TerminaStore: BEGIN

-- Declaracion de Constantes
DECLARE	Var_Control			CHAR(15);
DECLARE	Var_FechaSistema	CHAR(15);

-- Declaracion de Constantes
DECLARE	Cadena_Vacia		VARCHAR(1);
DECLARE	Fecha_Vacia			DATE;
DECLARE	Entero_Cero			INT(11);
DECLARE	Cons_SI				CHAR(1);
DECLARE	Cons_NO				CHAR(1);
DECLARE	EstatusDisp			CHAR(1);
DECLARE	ActBeneficiarios	INT(11);
DECLARE	BajaPantalla		INT(11);
DECLARE	BajaProcesoDisp		INT(11);

-- Asignacion de Constantes
SET Cadena_Vacia		:= '';				-- Cadena vacia.
SET Fecha_Vacia			:= '1900-01-01';	-- Fecha vacia.
SET Entero_Cero			:= 0;				-- Entero Cero.
SET	Cons_SI				:= 'S';				-- Constante Si.
SET	Cons_NO				:= 'N'; 			-- Constante No.
SET	EstatusDisp			:= 'D'; 			-- Estatus Procesada de Dispersión (Dispersada).
SET ActBeneficiarios	:= 01;				-- Actualizacion de beneficiarios.
SET BajaPantalla		:= 01;				-- Tipo de Baja por Modificación desde pantalla.
SET BajaProcesoDisp		:= 02;				-- Tipo de Baja por Dispersión Procesada.
SET Aud_FechaActual 	:= NOW();

ManejoErrores: BEGIN
	DECLARE EXIT HANDLER FOR SQLEXCEPTION
		BEGIN
			SET Par_NumErr := 999;
			SET Par_ErrMen := CONCAT('El SAFI ha tenido un problema al concretar la operacion. ',
									'Disculpe las molestias que esto le ocasiona. Ref: SP-APORTCONSOLIDADASBAJ');
			SET Var_Control:= 'sqlException' ;
		END;

	# SE ACTUALIZAN SI LA APORTACION ESTUVO CONSOLIDADA.
	UPDATE APORTACIONES AP
		INNER JOIN APORTCONSOLIDADAS AC ON AP.AportacionID = AC.AportConsID
	SET
		AP.ConsolidarSaldos = Cons_NO
	WHERE AC.AportacionID = Par_AportacionID;

	# SE ELIMINAN CONSOLIDACIONES.
	DELETE FROM APORTCONSOLIDADAS
	WHERE AportacionID = Par_AportacionID;

	SET	Par_NumErr := Entero_Cero;
	SET	Par_ErrMen := 'Consolidacion Eliminada Exitosamente.';
	SET Var_Control:= 'aportConsolID' ;

END ManejoErrores;

IF (Par_Salida = Cons_SI) THEN
	SELECT  Par_NumErr AS NumErr,
			Par_ErrMen AS ErrMen,
			Var_Control AS Control,
			Cadena_Vacia AS Consecutivo;
END IF;

END TerminaStore$$