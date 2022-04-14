-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- CONCEEDOSFINFIRAALT
DELIMITER ;
DROP PROCEDURE IF EXISTS `CONCEEDOSFINFIRAALT`;DELIMITER $$

CREATE PROCEDURE `CONCEEDOSFINFIRAALT`(
/* SP DE ALTA EN EL CATALOGO DE CONCEPTOS REPORTES FINANCIEROS PARA FIRA */
	Par_EstadoFinanID			INT(11),			# ID del Reporte Financiero, corresponde a TIPOSESTADOSFINAN.
	Par_ConceptoFinanID			DECIMAL(6,2),		# ID del Concepto Financiero
	Par_NumClien				INT(11),			# Identificador del Cliente
	Par_Descripcion				VARCHAR(300),		# Descripcion del Concepto Financiero
	Par_Desplegado				VARCHAR(300),		# Desplegado a Mostrar en el Reporte

	Par_CuentaContable			VARCHAR(500),		# Rango de Cuentas que Integran el Concepto Financiero
	Par_EsCalculado				CHAR(1),			# Indica si es un Campo calculado(Con formulas) S .- SI N .- NO
	Par_TipoCalculo				CHAR(1),			# Indica si es una suma o resta S.- Suma R.- Resta
	Par_NombreCampo				VARCHAR(20),		# Nombre del Campo, para el select dinamico
	Par_Espacios				INT(11),			# Numero  columnas vacias que se dejaran antes de pintar la cadena

	Par_Negrita					CHAR(1),			# Indica si la cadena se pintara como Negrita "S" = Si "N" = No
	Par_Sombreado				CHAR(1),			# Indica si la cadena ira sombreada en el valor  "S" = Si "N" = No
	Par_CombinarCeldas			INT(11),			# Indica el numero de celdas que se combinaran
	Par_CuentaFija				VARCHAR(45),		# Cuenta Fija que requiere el reporte regulatorio.
	Par_Presentacion			CHAR(1),			# Presentación del saldo en Positivo o Negativo: P : Positivo ( Se muestra el valor absoluto) N: Negativo (Se muestra el saldo con signo negativo) C: Contable ( Se muestra el saldo con el signo obtenido de la agrupación contable + ó - )

	Par_Tipo					CHAR(1),			# Tipo: E: Encabezado de un grupo de conceptos D: Detalle, concepto que no continene subcuentas en el reporte. O: Para los encabezados que se omite la sumatorio de sus subcuentas. I:  Para conceptos que requieren Formula contable, o que no se deben tomar en cuenta para la sumatoria.
	Par_Salida           		CHAR(1),			# Indica el tipo de salida S.- Si N.- No
	INOUT Par_NumErr     		INT,				# Numero de Error
	INOUT Par_ErrMen     		VARCHAR(400),		# Mensaje de Error
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
DECLARE	Var_Control     CHAR(15);
DECLARE	Var_ConsecID	INT(11);

-- Declaracion de Constantes
DECLARE	Cadena_Vacia	VARCHAR(1);
DECLARE	Fecha_Vacia		DATE;
DECLARE	Entero_Cero		INT(11);
DECLARE	SalidaSI        CHAR(1);
DECLARE	SalidaNO        CHAR(1);

-- Asignacion de Constantes
SET Cadena_Vacia		:= '';				-- Cadena vacia
SET Fecha_Vacia			:= '1900-01-01';	-- Fecha vacia
SET Entero_Cero			:= 0;				-- Entero Cero
SET	SalidaSI        	:= 'S';				-- Salida Si
SET	SalidaNO        	:= 'N'; 			-- Salida No
SET Aud_FechaActual 	:= NOW();

ManejoErrores: BEGIN
	DECLARE EXIT HANDLER FOR SQLEXCEPTION
		BEGIN
			SET Par_NumErr := 999;
			SET Par_ErrMen := CONCAT('El SAFI ha tenido un problema al concretar la operacion. ',
									'Disculpe las molestias que esto le ocasiona. Ref: SP-CONCEEDOSFINFIRAALT');
			SET Var_Control:= 'sqlException' ;
		END;

	SET Var_ConsecID := (SELECT COUNT(*) FROM CONCEEDOSFINFIRA
							WHERE EstadoFinanID = Par_EstadoFinanID
								AND NumClien = Par_NumClien AND NumTransaccion = Aud_NumTransaccion);
	SET Var_ConsecID := IFNULL(Var_ConsecID, Entero_Cero) + 1;
	SET Par_TipoCalculo := IFNULL(Par_TipoCalculo, Cadena_Vacia);

	INSERT INTO CONCEEDOSFINFIRA(
		EstadoFinanID,		ConceptoFinanID,		NumClien,				ConsecutivoID,			Descripcion,
		Desplegado,			CuentaContable,			EsCalculado,			TipoCalculo,			NombreCampo,
		Espacios,			Negrita,				Sombreado,				CombinarCeldas,			CuentaFija,
		Presentacion,		Tipo,					NumTransaccion)
	VALUES(
		Par_EstadoFinanID,	Par_ConceptoFinanID,	Par_NumClien,			Var_ConsecID,			Par_Descripcion,
		Par_Desplegado,		Par_CuentaContable,		Par_EsCalculado,		Par_TipoCalculo,		Par_NombreCampo,
		Par_Espacios,		Par_Negrita,			Par_Sombreado,			Par_CombinarCeldas,		Par_CuentaFija,
		Par_Presentacion,	Par_Tipo,				Aud_NumTransaccion);

	SET	Par_NumErr := Entero_Cero;
	SET	Par_ErrMen := 'Conceptos Grabados Exitosamente.';
	SET Var_Control:= 'paisID' ;

END ManejoErrores;

IF (Par_Salida = SalidaSI) THEN
    SELECT  Par_NumErr AS NumErr,
            Par_ErrMen AS ErrMen,
            Var_Control AS Control,
			Par_ConceptoFinanID AS Consecutivo;
END IF;

END TerminaStore$$