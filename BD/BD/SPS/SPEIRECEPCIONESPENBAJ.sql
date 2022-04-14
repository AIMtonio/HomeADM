-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- SPEIRECEPCIONESPENBAJ
DELIMITER ;
DROP PROCEDURE IF EXISTS `SPEIRECEPCIONESPENBAJ`;
DELIMITER $$

CREATE PROCEDURE `SPEIRECEPCIONESPENBAJ`(
	-- STORED PROCEDURE QUE SE ENCARGA DE ELIMINAR LA INFORMACION DE UNA RECEPCION PENDIETE DE SPEI
	Par_SpeiRecPenID			BIGINT(20),			-- Folio e identificador unico que es generado por el SP SPEIRECEPCIONESPENALT

	Par_Salida					CHAR(1),			-- Indica si el SP regresa una salida o no. S) SI, N) No
	INOUT Par_NumErr			INT(11),			-- Numero de Error
	INOUT Par_ErrMen			VARCHAR(400),		-- Mensaje del Error

	-- Parametros de Auditoria
	Aud_EmpresaID				INT(11),			-- Parametro de Auditoria
	Aud_Usuario					INT(11),			-- Parametro de Auditoria
	Aud_FechaActual				DATETIME,			-- Parametro de Auditoria
	Aud_DireccionIP				VARCHAR(20),		-- Parametro de Auditoria
	Aud_ProgramaID				VARCHAR(50),		-- Parametro de Auditoria
	Aud_Sucursal				INT(11),			-- Parametro de Auditoria
	Aud_NumTransaccion			BIGINT(20)			-- Parametro de Auditoria
)
TerminaStore: BEGIN
	-- Declaracion de Constantes
	DECLARE Cadena_Vacia		CHAR(1);			-- Indica una Cadena Vacia
	DECLARE Entero_Cero			INT(11);			-- Indica un Entero Vacio
	DECLARE Decimal_Cero		DECIMAL(18,2);		-- Indica un Decimal Vacio
	DECLARE Fecha_Vacia			DATE;				-- Indica una Fecha Vacia
	DECLARE Salida_SI			CHAR(1);			-- Indica un valor SI
	DECLARE Salida_NO			CHAR(1);			-- Indica un valor NO
	DECLARE Est_Reg				CHAR(1);			-- Estatus registrada

	-- Declaracion de Variables
	DECLARE Fecha_Sist			DATE;				-- Fecha del Sistema
	DECLARE Var_Control			VARCHAR(200);		-- Variable de control
	DECLARE Var_Consecutivo		BIGINT(20);			-- Variable consecutivo
	DECLARE Var_SpeiRecPenID	BIGINT(20);			-- ID del registro a borrar

	-- Asignacion de Constantes.
	SET Cadena_Vacia			:= '';				-- Cadena Vacia
	SET Fecha_Vacia				:= '1900-01-01';	-- Fecha Vacia
	SET Entero_Cero				:= 0;				-- Entero Cero
	SET Decimal_Cero			:= 0.0;				-- Decimal cero
	SET Salida_SI				:= 'S';				-- Salida SI
	SET Salida_NO				:= 'N';				-- Salida NO
	SET Est_Reg			:= 'R';						-- Estatus registrada

	ManejoErrores:BEGIN
		DECLARE EXIT HANDLER FOR SQLEXCEPTION
			BEGIN
				SET Par_NumErr	= 999;
				SET Par_ErrMen	= CONCAT('El SAFI ha tenido un problema al concretar la operacion. ',
									'Disculpe las molestias que esto le ocasiona. Ref: SP-SPEIRECEPCIONESPENBAJ');
				SET Var_Control = 'SQLEXCEPTION';
			END;

		SELECT SpeiRecepcionPenID
			INTO Var_SpeiRecPenID
			FROM SPEIRECEPCIONESPEN
			WHERE SpeiRecepcionPenID = Par_SpeiRecPenID;

		IF(IFNULL(Var_SpeiRecPenID, Entero_Cero) = Entero_Cero) THEN
			SET Par_NumErr 	:= 1;
			SET Par_ErrMen 	:= 'No se encontro la recepcion pendiente por eliminar.';
			SET Var_Control	:= 'SpeiRecepcionPenID';
			LEAVE ManejoErrores;
		END IF;

		DELETE FROM SPEIRECEPCIONESPEN
			WHERE SpeiRecepcionPenID = Par_SpeiRecPenID; 

		SET Par_NumErr	:= 000;
		SET Par_ErrMen	:= CONCAT('Recepcion SPEI Agregado Exitosamente: ', CONVERT(Par_SpeiRecPenID, CHAR));
		SET Var_Control	:= 'numero' ;
		SET Var_Consecutivo	:= Par_SpeiRecPenID;
	END ManejoErrores;

	IF (Par_Salida = Salida_SI) THEN
		SELECT	Par_NumErr AS NumErr,
				Par_ErrMen AS ErrMen,
				Var_Control AS control,
				Var_Consecutivo AS consecutivo,
				Var_ClaveRas AS campoGenerico;
	END IF;

END TerminaStore$$
