-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- CASTIGOMASVAL
DELIMITER ;
DROP PROCEDURE IF EXISTS `CASTIGOMASVAL`;DELIMITER $$

CREATE PROCEDURE `CASTIGOMASVAL`(
	Par_CreditoID					BIGINT(20),					# Numero de Crédito que se va castigar
	Par_MotivoCastigoID				INT(11),					# Corresponde a la tabla MOTIVOSCASTIGO
	Par_CobranzaID					INT(11),					# Corresponde a la tabla OPCIONESMENUREG
	Par_Salida						CHAR(1),					# Indica el tipo de salida S.- SI N.- No
	INOUT Par_NumErr				INT,						# Numero de Error
	INOUT Par_ErrMen				VARCHAR(400),				# Mensaje de Error
	/*Parametros de Auditoria*/
	Aud_EmpresaID					INT(11),
	Aud_Usuario						INT(11),
	Aud_FechaActual					DATETIME,
	Aud_DireccionIP					VARCHAR(15),
	Aud_ProgramaID					VARCHAR(50),
	Aud_Sucursal					INT(11),
	Aud_NumTransaccion				BIGINT(12)
)
TerminaStore: BEGIN
	-- Declaracion de Variables
	DECLARE Var_Control				VARCHAR(50);				-- ID del Control en pantalla
	DECLARE Var_Consecutivo 		VARCHAR(200);				-- Numero consecutivo
	DECLARE Var_CreditoID			BIGINT(11);					-- Numero de Credito
	DECLARE Var_Estatus				CHAR(1);					-- Estats del Crédito
	DECLARE Var_DiasAtraso			INT(11);					-- Numero de Dias de atraso
	DECLARE Var_DiasAtrasoMinProd	INT(11);					-- Numero de Dias de atraso x Producto
	DECLARE Var_DiasAtrasoMin		INT(11);					-- Numero de Dias de atraso Min x Credito
	DECLARE Var_ProductoCreditoID	INT(11);					-- Numero de Producto de Crédito

	-- Declaracion de constantes
	DECLARE Estatus_Activo			CHAR(1);
	DECLARE Entero_Cero				INT(11);
	DECLARE Cadena_Vacia			CHAR(1);
	DECLARE Cons_NO					CHAR(1);
	DECLARE SalidaSi				CHAR(1);
	-- Asignacion de constantes
	SET Estatus_Activo				:= 'A';						-- Estatus Activo
	SET Entero_Cero					:=0;						-- Entero Cero
	SET Cadena_Vacia				:= '';						-- Cadena Vacia
	SET Cons_NO						:= 'N';						-- Constante No
	SET SalidaSi					:= 'S';						-- Salida Si

	ManejoErrores: BEGIN
		DECLARE EXIT HANDLER FOR SQLEXCEPTION BEGIN
			SET Par_NumErr		:= 999;
			SET Par_ErrMen		:= CONCAT('El SAFI ha tenido un problema al concretar la operacion. ',
									'Disculpe las molestias que esto le ocasiona. Ref: SP-CASTIGOMASVAL');
			SET Var_Control		:= 'sqlException' ;
		END;

		SELECT
			CreditoID,		Estatus,		ProductoCreditoID,			DiasAtrasoMin
			INTO
			Var_CreditoID,	Var_Estatus,	Var_ProductoCreditoID,		Var_DiasAtrasoMin
			FROM CREDITOS
				WHERE CreditoID = Par_CreditoID;

		SELECT
			DiasAtraso
			INTO
			Var_DiasAtraso
			FROM SALDOSCREDITOS
				WHERE CreditoID = Par_CreditoID
					ORDER BY FechaCorte DESC
					LIMIT 1;

		SET Var_DiasAtrasoMinProd := (SELECT  DiasAtrasoMin
										FROM PRODUCTOSCREDITO
											WHERE ProducCreditoID = Var_ProductoCreditoID);



		IF(IFNULL(Var_CreditoID,Entero_Cero) = Entero_Cero) THEN
			SET Par_NumErr 		:= 001;
			SET Par_ErrMen 		:= CONCAT('El Credito ',Par_CreditoID,' No existe.');
			SET Var_Control 	:= 'creditoID' ;
			SET Var_Consecutivo	:= Par_CreditoID;
			LEAVE ManejoErrores;
		END IF;

		IF(IFNULL(Var_Estatus, Cadena_Vacia) NOT IN('V','B','A')) THEN
			SET Par_NumErr 		:= 002;
			SET Par_ErrMen 		:= CONCAT('El Credito ',Par_CreditoID,' No esta Activo.');
			SET Var_Control 	:= 'creditoID' ;
			SET Var_Consecutivo	:= Par_CreditoID;
			LEAVE ManejoErrores;
		END IF;

		IF(Var_DiasAtrasoMin IS NULL) THEN
			UPDATE CREDITOS SET
				DiasAtrasoMin = Var_DiasAtrasoMinProd
				WHERE CreditoID  = Par_CreditoID;
			SET Var_DiasAtrasoMin := Var_DiasAtrasoMinProd;
		END IF;
		SET Var_DiasAtraso := IFNULL(Var_DiasAtraso, Entero_Cero);
		SET Var_DiasAtrasoMin := IFNULL(Var_DiasAtrasoMin, Entero_Cero);

		IF(IFNULL(Var_DiasAtraso, Entero_Cero) < IFNULL(Var_DiasAtrasoMin, Entero_Cero)) THEN
			SET Par_NumErr 		:= 003;
			SET Par_ErrMen 		:= CONCAT('El Credito ',Par_CreditoID,' No Cumple con los dias Minimo de Atraso para poder realizar el Castigo.',
									'<br>Dias de Atraso: ',Var_DiasAtraso,'<br> Dias Min. Castigo: ', Var_DiasAtrasoMin);
			SET Var_Control 	:= 'creditoID' ;
			SET Var_Consecutivo	:= Par_CreditoID;
			LEAVE ManejoErrores;
		END IF;

		IF NOT EXISTS (SELECT MotivoCastigoID
			FROM MOTIVOSCASTIGO WHERE MotivoCastigoID = Par_MotivoCastigoID) THEN
			SET Par_NumErr 		:= 003;
			SET Par_ErrMen 		:= CONCAT('El Motivo del Castigo para el Credito ',Par_CreditoID,' No Existe.');
			SET Var_Control 	:= 'creditoID' ;
			SET Var_Consecutivo	:= Par_CreditoID;
			LEAVE ManejoErrores;
		END IF;

		IF NOT EXISTS (SELECT CodigoOpcion FROM OPCIONESMENUREG
					WHERE CodigoOpcion = Par_CobranzaID
					AND MenuID = 18/*COBRANZA*/ ) THEN
			SET Par_NumErr 		:= 003;
			SET Par_ErrMen 		:= CONCAT('El Tipo de Cobranza para el Credito ',Par_CreditoID,' No Existe.');
			SET Var_Control 	:= 'creditoID' ;
			SET Var_Consecutivo	:= Par_CreditoID;
			LEAVE ManejoErrores;
		END IF;

		SET Par_NumErr 		:= 000;
		SET Par_ErrMen 		:= CONCAT('El Credito Validado Exitosamente.');
		SET Var_Control 	:= 'creditoID' ;
		SET Var_Consecutivo	:= Par_CreditoID;

	END ManejoErrores;

	IF(Par_Salida = SalidaSi) THEN
		SELECT 	Par_NumErr AS NumErr,
		Par_ErrMen AS ErrMen,
		Var_Control AS Control,
		Var_Consecutivo AS Consecutivo;
	END IF;
END TerminaStore$$