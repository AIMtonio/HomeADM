-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- MAESTROPOLIZAALT
DELIMITER ;
DROP PROCEDURE IF EXISTS `MAESTROPOLIZAALT`;
DELIMITER $$


CREATE PROCEDURE `MAESTROPOLIZAALT`(
	-- SP que crea el encabezado de la poliza
	INOUT Par_Poliza	BIGINT,			-- Numero de Poliza
	Par_Empresa			INT,			-- Id de Empresa
	Par_Fecha			DATE,			-- Fecha
	Par_Tipo			CHAR(1),		-- Tipo
	Par_ConceptoID		INT(11),		-- Id del Concepto

    Par_Concepto		VARCHAR(150),	-- Concepto
	Par_Salida			CHAR(1),		-- Especifica si Hay Salida o No
	Aud_Usuario			INT,			-- Parametro de Auditoria
	Aud_FechaActual		DATETIME,		-- Parametro de Auditoria
	Aud_DireccionIP		VARCHAR(15),	-- Parametro de Auditoria

    Aud_ProgramaID		VARCHAR(50),	-- Parametro de Auditoria
	Aud_Sucursal		INT,			-- Parametro de Auditoria
	Aud_NumTransaccion	BIGINT			-- Parametro de Auditoria

)

TerminaStore: BEGIN

	DECLARE Fecha_Sistema  	DATE;
	DECLARE Var_NumErr		INT(11);
	DECLARE Var_ErrMen		VARCHAR(400);

	
	DECLARE	Cadena_Vacia	CHAR(1);
	DECLARE	Fecha_Vacia		DATE;
	DECLARE	Entero_Cero		INT;
	DECLARE	Salida_SI		CHAR(1);
	DECLARE	Salida_NO		CHAR(1);


	SET	Cadena_Vacia		:= '';
	SET	Fecha_Vacia			:= '1900-01-01';
	SET	Entero_Cero			:= 0;
	SET	Salida_SI			:= 'S';
	SET	Salida_NO			:= 'N';


	CALL MAESTROPOLIZASALT (
		Par_Poliza,			Par_Empresa,			Par_Fecha,			Par_Tipo,			Par_ConceptoID,
		Par_Concepto,		Salida_NO,				Var_NumErr,			Var_ErrMen,			Aud_Usuario,
		Aud_FechaActual,	Aud_DireccionIP,		Aud_ProgramaID,		Aud_Sucursal,		Aud_NumTransaccion
	);


	IF (Par_Salida = Salida_SI) THEN
		SELECT Var_NumErr AS NumErr,
		  Var_ErrMen  AS ErrMen,
		  'PolizaID' AS control,
		  Par_Poliza AS consecutivo;
	END IF;

END TerminaStore$$
