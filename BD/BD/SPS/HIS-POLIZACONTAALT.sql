-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- HIS-POLIZACONTAALT
DELIMITER ;
DROP PROCEDURE IF EXISTS `HIS-POLIZACONTAALT`;DELIMITER $$

CREATE PROCEDURE `HIS-POLIZACONTAALT`(
	Par_EjercicioID		INT(11),			-- Numero de Ejercicio
	Par_PeriodoID		INT(11),			-- Numero de Periodo
	Par_Salida			CHAR(1), 			-- Parametro de salida S= si, N= no
	INOUT Par_NumErr 	INT(11),			-- Parametro de salida numero de error
    	INOUT Par_ErrMen  	VARCHAR(400),		-- Parametro de salida mensaje de error

	Aud_EmpresaID		INT(11),			-- Parametro de Auditoria
	Aud_Usuario			INT(11),			-- Parametro de Auditoria
	Aud_FechaActual		DATETIME,			-- Parametro de Auditoria
	Aud_DireccionIP		VARCHAR(15),		-- Parametro de Auditoria
	Aud_ProgramaID		VARCHAR(50),		-- Parametro de Auditoria
	Aud_Sucursal		INT(11),			-- Parametro de Auditoria
	Aud_NumTransaccion	BIGINT(20)			-- Parametro de Auditoria
	)
TerminaStore: BEGIN
	-- Declaracion de Variables
	DECLARE	Var_FechaFinPer		DATE;
	DECLARE	Var_FechaIniPer		DATE;

	-- Declaracion de Constantes
	DECLARE	Cadena_Vacia		CHAR(1);
	DECLARE	Entero_Cero			INT;
    	DECLARE Salida_SI			CHAR(1);

	-- Asignacion de Constantes
	SET	Cadena_Vacia	:= '';			-- Cadena Vacia
	SET	Entero_Cero		:= 0;			-- Entero Cero
	SET Salida_SI		:= 'S';			-- Salida: SI

    ManejoErrores:BEGIN
		DECLARE EXIT HANDLER FOR SQLEXCEPTION
			BEGIN
				SET Par_NumErr	= 999;
				SET Par_ErrMen	= CONCAT('El SAFI ha tenido un problema al concretar la operacion. ',
									'Disculpe las molestias que esto le ocasiona. Ref: SP-HIS-POLIZACONTAALT');
			END;

SELECT Fin, Inicio INTO Var_FechaFinPer, Var_FechaIniPer
			FROM PERIODOCONTABLE
			WHERE EjercicioID = Par_EjercicioID
			  AND PeriodoID = Par_PeriodoID;

	SET Aud_FechaActual := CURRENT_TIMESTAMP();

	INSERT `HIS-POLIZACONTA`  (
				EmpresaID,			PolizaID,		Fecha,				Tipo,				ConceptoID,
				Concepto,			Usuario	,		FechaActual,		DireccionIP,		ProgramaID,
				Sucursal,			NumTransaccion)

		SELECT	EmpresaID,			PolizaID,		Fecha,				Tipo,				ConceptoID,
				Concepto,			Usuario,		FechaActual,		DireccionIP,		ProgramaID,
				Sucursal,			NumTransaccion
		FROM		POLIZACONTABLE
		WHERE 	Fecha >= Var_FechaIniPer
		AND 		Fecha <= Var_FechaFinPer;

		DELETE FROM  POLIZACONTABLE
			WHERE Fecha >= Var_FechaIniPer
			AND	 Fecha <= Var_FechaFinPer;

		SET Par_NumErr	:= Entero_Cero;
		SET Par_ErrMen	:= 'Poliza Contable Agregado Exitosamente';

	END ManejoErrores;

		IF(Par_Salida = Salida_SI)THEN
			SELECT 	Par_NumErr AS NumErr,
					Par_ErrMen AS ErrMen;
		END IF;

END TerminaStore$$