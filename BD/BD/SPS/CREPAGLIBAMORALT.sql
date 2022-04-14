-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- CREPAGLIBAMORALT
DELIMITER ;
DROP PROCEDURE IF EXISTS `CREPAGLIBAMORALT`;DELIMITER $$

CREATE PROCEDURE `CREPAGLIBAMORALT`(
	/*SP que Inserta las amortizaciones TMPPAGAMORSIM del Simulador de Creditos Pasivos (FONDEO)*/
	Par_Consecutivo			INT(11),
	Par_Capital				DECIMAL(12,2),
	Par_FechaInicio			DATE,
	Par_FechaVenc			DATE,
	Par_DiaHabilSig			CHAR(1),

	Par_Salida				CHAR(1),		# Salida S:Si N:No
	INOUT Par_NumErr		INT(11),		# Numero de error
	INOUT Par_ErrMen		VARCHAR(400),	# Mensaje de Error
	/*Parametros de Auditoria*/
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
	DECLARE Var_Capital		CHAR(1);
	DECLARE Var_CapInt		CHAR(1);
	DECLARE Var_EsHabil		CHAR;
	DECLARE Var_SI			CHAR(1);
	DECLARE Salida_SI		CHAR(1);
	DECLARE Var_Control		VARCHAR(50);			# Variable con el ID del control de Pantalla
	DECLARE Var_Consecutivo	VARCHAR(50);			# Variable campo de pantalla

	-- Declaracion de Constantes
	DECLARE Entero_Negativo	INT(11);
	DECLARE Entero_Cero		INT(11);
	DECLARE FechaVig		DATE;
	DECLARE CapInt			CHAR(1);
	DECLARE Fre_Dias		INT(11);
	-- Asignacion de Constantes
	SET	Entero_Cero			:= 0;
	SET	Var_SI				:= 'S';
	SET	Salida_SI				:= 'S';
	SET Var_Capital			:= 'C';
	SET Var_CapInt			:= 'G';
	SET Entero_Negativo		:= -1;

	ManejoErrores: BEGIN
		DECLARE EXIT HANDLER FOR SQLEXCEPTION BEGIN
			SET Par_NumErr	:= 999;
			SET Par_ErrMen	:= CONCAT('El SAFI ha tenido un problema al concretar la operacion. ',
									'Disculpe las molestias que esto le ocasiona. Ref: SP-CREPAGLIBAMORALT');
			SET Var_Control	:= 'SQLEXCEPTION';
		END;

		IF(IFNULL(Par_Capital, Entero_Cero))!= Entero_Cero THEN
			IF(Par_Capital < Entero_Cero)THEN
				SET Par_NumErr	:= 001;
				SET Par_ErrMen	:= 'El monto no puede ser negativo.';
				SET Var_Control	:= 'capital';
				SET Var_Consecutivo := '';
				LEAVE ManejoErrores;
			END IF;
		END IF;

		IF(Par_DiaHabilSig = Var_SI) THEN
			CALL DIASFESTIVOSCAL(
				Par_FechaVenc,			Entero_Cero,		FechaVig,			Var_EsHabil,		Aud_EmpresaID,
				Aud_Usuario,			Aud_FechaActual,	Aud_DireccionIP,	Aud_ProgramaID,		Aud_Sucursal,
				Aud_NumTransaccion);
		  ELSE
			CALL DIASHABILANTERCAL(
				Par_FechaVenc,		Entero_Cero,			FechaVig,		Aud_EmpresaID,		Aud_Usuario,
				Aud_FechaActual,	Aud_DireccionIP,		Aud_ProgramaID,	Aud_Sucursal,		Aud_NumTransaccion);
		END IF;

		IF(Par_Capital = Entero_Cero) THEN
			SET CapInt := Var_Capital;
		  ELSE
			SET CapInt := Var_CapInt;
		END IF;

		SET Fre_Dias	:= (DATEDIFF(Par_FechaVenc,Par_FechaInicio));

		INSERT INTO TMPPAGAMORSIM(
			Tmp_Consecutivo,	Tmp_FecIni,				Tmp_FecFin,		Tmp_FecVig,		Tmp_Capital,
			Tmp_CapInt,			NumTransaccion,			Tmp_Dias)
		VALUES(
			Par_Consecutivo,	Par_FechaInicio,		Par_FechaVenc,	FechaVig,		Par_Capital,
			CapInt,				Aud_NumTransaccion,		Fre_Dias);

		SET Par_NumErr		:= 000;
		SET Par_ErrMen		:= CONCAT('Agregada correctamente la Amortizacion Temporal.');
		SET Var_Control		:= 'simula';
		SET Var_Control		:= '';
	END ManejoErrores;  -- END del Handler de Errores

	IF (Par_Salida = Salida_SI) THEN
		SELECT  Par_NumErr 			AS NumErr,
				Par_ErrMen			AS ErrMen,
				Var_Control			AS control,
				Var_Consecutivo 	AS consecutivo;
	END IF;
END TerminaStore$$