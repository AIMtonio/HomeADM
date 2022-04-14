-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- MAESTROPOLIZASALT
DELIMITER ;
DROP PROCEDURE IF EXISTS `MAESTROPOLIZASALT`;
DELIMITER $$

CREATE PROCEDURE `MAESTROPOLIZASALT`(
-- STORE PARA REALIZAR EL MAESTRO DE POLIZAS
	INOUT	Par_Poliza	BIGINT(20),			-- Numero de Poliza
	Par_Empresa			INT(11),			-- Id de Empresa
	Par_Fecha			DATE,				-- Fecha
	Par_Tipo			CHAR(1),			-- Tipo
	Par_ConceptoID		INT(11),			-- Id del Concepto
	Par_Concepto		VARCHAR(150),		-- Concepto

	Par_Salida			CHAR(1), 			-- Especifica si Hay Salida o No
	INOUT	Par_NumErr	INT(11),			-- Control de Errores: Numero de Error
	INOUT	Par_ErrMen	VARCHAR(400),		-- Control de Errores: Descripcion del Error

	Aud_Usuario			INT(11),			-- Parametro de Auditoria
	Aud_FechaActual		DATETIME,			-- Parametro de Auditoria
	Aud_DireccionIP		VARCHAR(15),		-- Parametro de Auditoria
	Aud_ProgramaID		VARCHAR(50),		-- Parametro de Auditoria
	Aud_Sucursal		INT(11),			-- Parametro de Auditoria
	Aud_NumTransaccion	BIGINT(20)			-- Parametro de Auditoria
)
TerminaStore: BEGIN

	-- Declaracion de Variables
	DECLARE Var_Control	    VARCHAR(100);  	-- Variable de control
	DECLARE Var_Consecutivo	BIGINT(20);     -- Variable consecutivo
	DECLARE Var_Ejercicio	INT;
	DECLARE Var_Periodo		INT;
	DECLARE Par_Fin			BIGINT(12);

	-- Declaracion de Constante
	DECLARE	Cadena_Vacia	CHAR(1);
	DECLARE	Fecha_Vacia		DATE;
	DECLARE	Entero_Cero		INT;
	DECLARE	Salida_NO		CHAR(1);
	DECLARE	Salida_SI		CHAR(1);
	DECLARE EstatusEBSNo	CHAR(1);


	SET	Cadena_Vacia		:= '';					-- Cadena Vacia
	SET	Fecha_Vacia			:= '1900-01-01';		-- Fecha Vacia
	SET	Entero_Cero			:= 0;					-- Entero en Cero
	SET	Salida_NO       	:= 'N';					-- Salida en pantalla NO
	SET Salida_SI       	:= 'S';                 -- Salida si
	SET EstatusEBSNo		:= 'N';					-- Valor DEFAULT para el estado de exportación EBS. N.- NO

	ManejoErrores:BEGIN
		DECLARE EXIT HANDLER FOR SQLEXCEPTION BEGIN
			SET Par_NumErr	:= 999;
			SET Par_ErrMen	:= CONCAT('El SAFI ha tenido un problema al concretar la operacion. ',
								'Disculpe las molestias que esto le ocasiona. Ref: SP-MAESTROPOLIZASALT');
			SET Var_Control := 'SQLEXCEPTION';
		END;

		IF( IFNULL(Par_Empresa, Entero_Cero) = Entero_Cero) THEN
			SET Par_NumErr		:= 	001;
			SET Par_ErrMen		:=	'El ID de la Empresa esta Vacio.';
			SET Var_Control		:=  'polizaID' ;
			LEAVE ManejoErrores;
		END IF;

		IF( IFNULL(Par_Fecha, Fecha_Vacia) = Fecha_Vacia) THEN
			SET Par_NumErr		:= 	002;
			SET Par_ErrMen		:=	'La Fecha esta Vacia.';
			SET Var_Control		:=  'polizaID' ;
			LEAVE ManejoErrores;
		END IF;

		IF( IFNULL(Par_Tipo, Cadena_Vacia) = Cadena_Vacia) THEN
			SET Par_NumErr		:= 	003;
			SET Par_ErrMen		:=	'El Tipo de Poliza esta Vacio.';
			SET Var_Control		:=  'polizaID' ;
			LEAVE ManejoErrores;
		END IF;

		IF( IFNULL(Par_Concepto, Cadena_Vacia) = Cadena_Vacia) THEN
			SET Par_NumErr		:= 	005;
			SET Par_ErrMen		:=	'El Concepto esta Vacio.';
			SET Var_Control		:=  'polizaID' ;
			LEAVE ManejoErrores;
		END IF;

		-- Consecutivo General
		 SET Par_Poliza := (SELECT	IFNULL(MAX(PolizaID), 0) + 1	FROM	POLIZACONTABLE );
		 SET Par_Fin			:= (SELECT IFNULL(MAX(PolizaFinal),0)	FROM PERIODOCONTABLE	WHERE Estatus='C');
		IF (Par_Poliza = Par_Fin) THEN
			SET Par_Poliza := Par_Poliza+1;
		END IF;

		SET Aud_FechaActual	:= NOW();

		INSERT INTO POLIZACONTABLE (
			PolizaID,		EmpresaID,				Fecha, 				Tipo,				ConceptoID,
			Concepto, 		Usuario,				FechaActual,		DireccionIP,		ProgramaID,
            Sucursal,   	NumTransaccion)
		VALUES(
			Par_Poliza,			Par_Empresa,		Par_Fecha, 			Par_Tipo,			Par_ConceptoID,
            Par_Concepto,		Aud_Usuario	,		Aud_FechaActual,	Aud_DireccionIP,	Aud_ProgramaID,
            Aud_Sucursal,		Aud_NumTransaccion);

		SET Par_NumErr	:= 000;
		SET Par_ErrMen	:= CONCAT("Poliza Agregada: ", CAST(Par_Poliza AS CHAR));
		SET Var_Control	:= 'polizaID' ;

	END ManejoErrores;

	IF (Par_Salida = Salida_SI) THEN
		SELECT	Par_NumErr 	AS NumErr,
				Par_ErrMen 	AS ErrMen,
				Var_Control AS control,
				Par_Poliza 	AS consecutivo;
	END IF;

END TerminaStore$$