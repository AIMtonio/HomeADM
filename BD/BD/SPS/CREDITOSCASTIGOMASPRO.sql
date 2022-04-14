-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- CREDITOSCASTIGOMASPRO
DELIMITER ;
DROP PROCEDURE IF EXISTS `CREDITOSCASTIGOMASPRO`;DELIMITER $$

CREATE PROCEDURE `CREDITOSCASTIGOMASPRO`(
/*Proceso de Condonacion Masiva*/
	Par_TransaccionID				BIGINT(20),					# Numero de Transaccion con el que se hizo la carga
	Par_FechaCarga					DATE,
	Par_Salida						CHAR(1),
	INOUT	Par_NumErr				INT(11),
	INOUT	Par_ErrMen				VARCHAR(400),
	/*Parametros de Auditoria*/
	Aud_EmpresaID					INT(11),
	Aud_Usuario						INT(11),
	Aud_FechaActual					DATETIME,
	Aud_DireccionIP					VARCHAR(15),
	Aud_ProgramaID					VARCHAR(50),
	Aud_Sucursal					INT(11),
	Aud_NumTransaccion				BIGINT(20)
)
TerminaStore:BEGIN
	-- Declaracion de Variables
	DECLARE Var_Control			VARCHAR(50);
	DECLARE Var_CreditoID 		BIGINT(12);
	DECLARE Var_PolizaID		BIGINT(20);
	DECLARE Var_MotivoCastigoID	INT(11);
	DECLARE Var_FechaSistema	DATE;
	DECLARE Var_TipoCobranza	INT(11);
	DECLARE Var_Observaciones	VARCHAR(500);
	DECLARE Var_Consecutivo		VARCHAR(50);

	-- Declaracion de Constantes
	DECLARE Entero_Cero 		INT(1);
	DECLARE Cadena_Vacia 		CHAR(1);
	DECLARE Decimal_Cero		DECIMAL(12,2);
	DECLARE ConceptoCon			INT(11);
	DECLARE ConceptoContDesc	VARCHAR(150);
	DECLARE Salida_NO			CHAR(1);
	DECLARE Salida_SI			CHAR(1);
	DECLARE Pol_Automatica		CHAR(1);
	DECLARE Cons_No				CHAR(1);

	-- Cursores
	DECLARE CURSORCRECASTIGO CURSOR FOR
		SELECT
			CreditoID,		MotivoCastigoID,	CobranzaID,	Observaciones
			FROM
				CREDITOSACASTIGAR
				WHERE Estatus ='N'
				AND FechaCarga = Par_FechaCarga
				AND TransaccionID = Par_TransaccionID;

	-- Asignacion de constantes
	SET Entero_Cero				:= 0;
	SET Cadena_Vacia			:= '';
	SET Decimal_Cero			:= 0.00;
	SET Pol_Automatica			:= 'A';
	SET ConceptoCon				:= 59;
	SET ConceptoContDesc		:= 'CASTIGO DE CARTERA';
	SET Salida_NO				:= 'N';
	SET Salida_SI				:= 'S';
	SET Cons_No					:= 'N';

	ManejoErrores:BEGIN
		DECLARE EXIT HANDLER FOR SQLEXCEPTION BEGIN
			SET Par_NumErr 		:= 999;
			SET Par_ErrMen 		:= CONCAT('El SAFI ha tenido un problema al concretar la operacion. ',
								'Disculpe las molestias que esto le ocasiona. Ref: SP-CREDITOSCASTIGOMASPRO');
			SET Var_Control		:= 'sqlException' ;
		END;

		SET Var_FechaSistema := (SELECT FechaSistema FROM PARAMETROSSIS);
		SET Aud_FechaActual := NOW();
		OPEN CURSORCRECASTIGO;
			BEGIN
				DECLARE EXIT HANDLER FOR SQLSTATE '02000' BEGIN END;
				LOOP
					FETCH CURSORCRECASTIGO INTO
					Var_CreditoID,			Var_MotivoCastigoID,	Var_TipoCobranza,		Var_Observaciones;

					CALL TRANSACCIONESPRO(Aud_NumTransaccion);

					CALL MAESTROPOLIZASALT(
					Var_PolizaID,			Aud_EmpresaID,		Var_FechaSistema, 	Pol_Automatica,		ConceptoCon,
					ConceptoContDesc,		Salida_NO,			Par_NumErr,			Par_ErrMen,			Aud_Usuario,
					Aud_FechaActual,		Aud_DireccionIP,	Aud_ProgramaID,		Aud_Sucursal,		Aud_NumTransaccion);

					IF(Par_NumErr!= Entero_Cero) THEN
						SET Par_ErrMen := CONCAT(Par_ErrMen,' <br>Credito: ',Var_CreditoID);
						LEAVE ManejoErrores;
					END IF;

					CALL CRECASTIGOPRO(
						Var_CreditoID,		Var_PolizaID,			Var_MotivoCastigoID,	Var_Observaciones,	null,
						Var_TipoCobranza,	Cons_No,				Salida_NO,				Aud_EmpresaID,		Par_NumErr,
						Par_ErrMen,			Aud_Usuario,			Aud_FechaActual,		Aud_DireccionIP,	Aud_ProgramaID,
						Aud_Sucursal,		Aud_NumTransaccion);

					IF(Par_NumErr!= Entero_Cero) THEN
						SET Par_ErrMen := CONCAT(Par_ErrMen,' <br>Credito: ',Var_CreditoID);
						LEAVE ManejoErrores;
					END IF;

					UPDATE CREDITOSACASTIGAR SET
						Estatus='A',
						Usuario = Aud_Usuario,
						FechaActual = Aud_FechaActual,
						DireccionIP = Aud_DireccionIP,
						ProgramaID 	= Aud_ProgramaID,
						Sucursal	= Aud_Sucursal,
						NumTransaccion = Aud_NumTransaccion
						WHERE CreditoID = Var_CreditoID;
				END LOOP;
			END;
		CLOSE CURSORCRECASTIGO;

		SET Par_NumErr 	:= Entero_Cero;
		SET Par_ErrMen	:= 'Castigo Realizado Exitosamente.';
	END ManejoErrores;

	IF (Par_Salida = Salida_SI) THEN
			SELECT 	Par_NumErr	AS NumErr,
					Par_ErrMen	AS ErrMen,
					Var_Control AS Control,
					Var_Consecutivo AS Consecutivo;
	END IF;
END TerminaStore$$