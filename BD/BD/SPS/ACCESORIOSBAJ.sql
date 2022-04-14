-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- ACCESORIOSBAJ
DELIMITER ;
DROP PROCEDURE IF EXISTS `ACCESORIOSBAJ`;DELIMITER $$

CREATE PROCEDURE `ACCESORIOSBAJ`(
-- ==========================================================
-- SP PARA DAR DE BAJA LOS ACCESORIOS A COBRAR DE UN CREDITO
-- ==========================================================
	Par_Salida           		CHAR(1),		# Indica el tipo de salida S.- Si N.- No
	INOUT Par_NumErr     		INT,			# Numero de Error
	INOUT Par_ErrMen     		VARCHAR(400),	# Mensaje de Error

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

-- Declaracion de Variables
DECLARE	Var_Control     		CHAR(15); 		# Variable de Control en Pantalla
DECLARE	Var_Consecutivo 		INT(11); 		# Varibale de Consecutivo en Pantalla
DECLARE Var_NumRegistros 		INT(11); 		# Variable Número de Registros
DECLARE Var_NumRegistrosCuenta	INT(11); 		# Varibale número de registros por cuenta
DECLARE Var_NombreCorto			CHAR(10); 		# Nombre corto del accesorio
DECLARE Var_ConceptoCarteraID	INT(11); 		# Id del cocepto de cartera por accesorio

-- Declaracion de Constantes
DECLARE	Cadena_Vacia	VARCHAR(1); 	# Constante Cadena Vacía
DECLARE	Fecha_Vacia		DATE; 			# Constante Fecha Vacía
DECLARE	Entero_Cero		INT(11); 		# Constante Entero Cero
DECLARE	SalidaSI        CHAR(1); 		# Constante Salida Si
DECLARE	SalidaNO        CHAR(1); 		# Constante Salida No
DECLARE String_IVA		VARCHAR(4); 	# Constante IVA

-- Asignacion de Constantes
SET Cadena_Vacia		:= '';				# Cadena vacia
SET Fecha_Vacia			:= '1900-01-01';	# Fecha vacia
SET Entero_Cero			:= 0;				# Entero Cero
SET	SalidaSI        	:= 'S';				# Salida Si
SET	SalidaNO        	:= 'N'; 			# Salida No
SET Aud_FechaActual 	:= NOW();			# Fecha Actual
SET String_IVA			:= 'IVA '; 			# Cadena IVA

ManejoErrores: BEGIN
	DECLARE EXIT HANDLER FOR SQLEXCEPTION
		BEGIN
			SET Par_NumErr := 999;
			SET Par_ErrMen := CONCAT('El SAFI ha tenido un problema al concretar la operacion. ',
									'Disculpe las molestias que esto le ocasiona. Ref: SP-ACCESORIOSBAJ');
			SET Var_Control:= 'SQLEXCEPTION' ;
		END;

	DELETE FROM TMP_ACCESORIOS_PROT;
    DELETE FROM TMP_ACCESORIOS_BAJ;
    -- Determina que accesorios no se puden eliminar
    INSERT INTO	TMP_ACCESORIOS_PROT(
			AccesorioID,		NombreCorto,		EmpresaID,			Usuario,			FechaActual,
			DireccionIP,		ProgramaID,			Sucursal,			NumTransaccion
    )
	SELECT 	AccesorioID,		NombreCorto,		Par_EmpresaID,		Aud_Usuario,		Aud_FechaActual,
			Aud_DireccionIP,	Aud_ProgramaID,		Aud_Sucursal,		Aud_NumTransaccion
        FROM ACCESORIOSCRED Ac
			INNER JOIN CONCEPTOSCARTERA Cc
				ON Ac.NombreCorto=Cc.Descripcion
                OR Cc.Descripcion = CONCAT(Ac.NombreCorto,Cadena_Vacia)
			INNER JOIN CUENTASMAYORCAR Cm
				ON Cc.ConceptoCarID=Cm.ConceptoCarID;

	-- Determina que otros accesorios no se pueden eliminar de acuerdo al esquema por productos
   INSERT INTO	TMP_ACCESORIOS_PROT(
			AccesorioID,		NombreCorto,		EmpresaID,			Usuario,			FechaActual,
			DireccionIP,		ProgramaID,			Sucursal,			NumTransaccion
    )
	SELECT DISTINCT(Ac.AccesorioID) AS AccesorioID,
			NombreCorto,		Par_EmpresaID,		Aud_Usuario,		Aud_FechaActual,	Aud_DireccionIP,
            Aud_ProgramaID,		Aud_Sucursal,		Aud_NumTransaccion
		FROM ACCESORIOSCRED Ac
		INNER JOIN ESQUEMAACCESORIOSPROD Esq
			ON Esq.AccesorioID = Ac.AccesorioID;

    -- Determina que accesorios y conceptos de cartera se pueden eliminar
    INSERT INTO	TMP_ACCESORIOS_BAJ(
			AccesorioID,		ConceptoCarID,		EmpresaID,			Usuario,			FechaActual,
			DireccionIP,		ProgramaID,			Sucursal,			NumTransaccion
    )
	SELECT 	AccesorioID,		ConceptoCarID,		Par_EmpresaID,		Aud_Usuario,		Aud_FechaActual,
			Aud_DireccionIP,	Aud_ProgramaID,		Aud_Sucursal,		Aud_NumTransaccion
	FROM ACCESORIOSCRED Ac
		INNER JOIN CONCEPTOSCARTERA Cc
			ON Ac.NombreCorto=Cc.Descripcion
		WHERE AccesorioID NOT IN (SELECT DISTINCT(AccesorioID) FROM TMP_ACCESORIOS_PROT);

    -- Determina todos los accesorios y conceptos de cartera que puede elimiar Accesorio e IVA
	INSERT TMP_ACCESORIOS_BAJ
		SELECT	AccesorioID,		ConceptoCarID,		Par_EmpresaID,		Aud_Usuario,		Aud_FechaActual,
				Aud_DireccionIP,	Aud_ProgramaID,		Aud_Sucursal,		Aud_NumTransaccion
		FROM CONCEPTOSCARTERA cc
			INNER JOIN ACCESORIOSCRED ac
			ON cc.Descripcion = CONCAT(String_IVA,ac.NombreCorto)
		WHERE AccesorioID NOT IN (SELECT DISTINCT(AccesorioID) FROM TMP_ACCESORIOS_PROT);

	-- Elimina Accesorios
	DELETE FROM ACCESORIOSCRED
	WHERE AccesorioID IN (SELECT AccesorioID FROM TMP_ACCESORIOS_BAJ);

    -- Elimina conceptos
    DELETE FROM CONCEPTOSCARTERA
	WHERE ConceptoCarID IN (SELECT ConceptoCarID FROM TMP_ACCESORIOS_BAJ);

	SET	Par_NumErr := Entero_Cero;
	SET	Par_ErrMen := 'Accesorios Eliminados Exitosamente.';
	SET Var_Control:= 'accesorioID' ;

END ManejoErrores;

IF (Par_Salida = SalidaSI) THEN
    SELECT  Par_NumErr AS NumErr,
            Par_ErrMen AS ErrMen,
            Var_Control AS Control,
			Var_Consecutivo AS Consecutivo;
END IF;

END TerminaStore$$