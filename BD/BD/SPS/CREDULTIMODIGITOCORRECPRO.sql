-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- CREDULTIMODIGITOCORRECPRO
DELIMITER ;
DROP PROCEDURE IF EXISTS `CREDULTIMODIGITOCORRECPRO`;
DELIMITER $$


CREATE PROCEDURE `CREDULTIMODIGITOCORRECPRO`(
/* SP PARA CORREGIR EL ULTIMO DIGITO DE LOS CREDITOS QUE TUVIERON INCIDENCIAS EN LA GENERACION DE SUS ACCESORIOS*/
	Par_CreditoID			BIGINT(12),
    Par_Numero_Cuota        INT(11),

	Par_Salida				CHAR(1),
	INOUT Par_NumErr		INT(11),
	INOUT Par_ErrMen		VARCHAR(400),

	Par_EmpresaID			INT(11),
	Aud_Usuario				INT(11),
	Aud_FechaActual			DATETIME,
	Aud_DireccionIP			VARCHAR(15),
	Aud_ProgramaID			VARCHAR(50),

	Aud_Sucursal			INT(11),
	Aud_NumTransaccion		BIGINT(12)
	)
TerminaStore: BEGIN

	-- Declaracion de Variables
    DECLARE Var_Control			        VARCHAR(100);		-- Variable Control
	DECLARE Cadena_Vacia    	        CHAR(1);

	-- Declaracion de constantes
	DECLARE Entero_Cero				INT;
    DECLARE Decimal_Cero			DECIMAL(12,2);
	DECLARE	SalidaNO				CHAR(1);
	DECLARE	SalidaSI				CHAR(1);
	DECLARE Alta_CreNuevo			INT(11);
	DECLARE Alta_CreReestructura 	INT(11);
	DECLARE Estatus_Inactivo		CHAR(1);
	DECLARE Estatus_Vigente			CHAR(1);

	-- Asignacion  de constantes
	SET	Entero_Cero				:= 0;			        -- Constante Entero valor cero
    SET Decimal_Cero			:= 0.00;		        -- Constante DECIMAL Cero
	SET	Estatus_Inactivo		:= 'I';			        --  Estatus Inactivo
	SET Estatus_Vigente			:= 'V';			        -- Estatus vigente
	SET	SalidaNO				:= 'N';			        -- Constante Salida NO
	SET	SalidaSI				:= 'S';			        -- Constante Salida SI
    SET Cadena_Vacia    		:= '';                  -- Cadena Vacia

	ManejoErrores: BEGIN
		DECLARE EXIT HANDLER FOR SQLEXCEPTION
		BEGIN
			SET Par_NumErr := 999;
			SET Par_ErrMen := CONCAT('El SAFI ha tenido un problema al concretar la operacion. ',
								'Disculpe las molestias que esto le ocasiona. Ref: SP-CREDITOSCORRECIONPRO');
			SET Var_Control := 'sqlexception';
		END;

		IF(IFNULL(Par_CreditoID, Cadena_Vacia) = Cadena_Vacia) THEN
			SET Par_NumErr := 1;
			SET	Par_ErrMen := 'El CreditoID No puede ser vacio.';
			LEAVE ManejoErrores;
		END IF;

        UPDATE DETALLEACCESORIOS DET SET
            DET.MontoCuota			= 	( DET.MontoAccesorio - (ROUND(DET.MontoAccesorio/Par_Numero_Cuota,2) * (Par_Numero_Cuota - 1))),
            DET.MontoIVACuota       = 	IF (DET.CobraIVA = SalidaNO, Entero_Cero, (DET.MontoIVAAccesorio - (ROUND(DET.MontoIVAAccesorio/Par_Numero_Cuota,2) * (Par_Numero_Cuota - 1)))),
            DET.MontoIntCuota  		= 	IF (DET.GeneraInteres = SalidaNO, Entero_Cero, (DET.MontoInteres - (ROUND(DET.MontoInteres/Par_Numero_Cuota,2) * (Par_Numero_Cuota - 1)))),
            DET.MontoIVAIntCuota	= 	IF (DET.CobraIVAInteres = SalidaNO, Entero_Cero, (DET.MontoIVAInteres - (ROUND(DET.MontoIVAInteres/Par_Numero_Cuota,2) * (Par_Numero_Cuota - 1))))
            WHERE DET.CreditoID = Par_CreditoID AND DET.AmortizacionID = Par_Numero_Cuota;

		SET Par_NumErr	:= 0;
		SET Par_ErrMen	:= 'Credito Corregido Exitosamente';

	END ManejoErrores;  -- End del Handler de Errores


	IF (Par_Salida = SalidaSI) THEN
		SELECT  CONVERT(Par_NumErr, CHAR(3)) AS NumErr,
				Par_ErrMen 		AS ErrMen,
				'creditoID' 	AS control,
				Par_CreditoID 	AS consecutivo;
	 END IF;

END TerminaStore$$