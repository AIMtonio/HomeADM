-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- PLDHISMATRIZRIESGOXCONCALT
DELIMITER ;
DROP PROCEDURE IF EXISTS `PLDHISMATRIZRIESGOXCONCALT`;DELIMITER $$

CREATE PROCEDURE `PLDHISMATRIZRIESGOXCONCALT`(
	/*SP realiza respaldo de la configuración de la matriz*/
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
	DECLARE Var_Control					VARCHAR(50);				# ID del Control en pantalla
	DECLARE Var_Consecutivo 			VARCHAR(200);				# Numero consecutivo para la imagen a digitalizar
	DECLARE Var_RegDiferentes 			INT(11);					# Numero de registros diferentes
	DECLARE Var_FolioID					INT(11);					# Numero de Folio
	DECLARE Var_FechaActual				DATE;

	-- Declaracion de constantes
	DECLARE Estatus_Activo			CHAR(1);
	DECLARE Entero_Cero				INT(11);
	DECLARE Cadena_Vacia			CHAR(1);
	DECLARE Cons_NO					CHAR(1);
	DECLARE SalidaSi				CHAR(1);

	-- Asignacion de constantes
	SET Estatus_Activo			:= 'A';							-- Estatus Activo
	SET Entero_Cero				:=0;							-- Entero Cero
	SET Cadena_Vacia			:= '';							-- Cadena Vacia
	SET Cons_NO					:= 'N';							-- Constante No
	SET SalidaSi				:= 'S';							-- Salida Si

	ManejoErrores: BEGIN
		DECLARE EXIT HANDLER FOR SQLEXCEPTION BEGIN
			SET Par_NumErr		:= 999;
			SET Par_ErrMen		:= CONCAT('El SAFI ha tenido un problema al concretar la operacion. ',
									'Disculpe las molestias que esto le ocasiona. Ref: SP-PLDHISMATRIZRIESGOXCONCALT');
			SET Var_Control		:= 'sqlException' ;
		END;

		SET Var_RegDiferentes := (SELECT COUNT(*) FROM
								(SELECT
									CONCAT(IF(PLD.MatrizCatalogoID = IFNULL(HIS.MatrizCatalogoID,Entero_Cero),'S','N'),
									IF(PLD.Descripcion = IFNULL(HIS.Descripcion,Cadena_Vacia),'S','N'),
									IF(PLD.Porcentaje = IFNULL(HIS.Porcentaje,Entero_Cero),'S','N'),
									IF(PLD.LimiteInferior = IFNULL(HIS.LimiteInferior,Entero_Cero),'S','N'),
									IF(PLD.LimiteSuperior = IFNULL(HIS.LimiteSuperior,Entero_Cero),'S','N')) AS Comparacion
										FROM PLDMATRIZRIESGOXCONC AS PLD LEFT JOIN
										PLDHISMATRIZRIESGOXCONC AS HIS ON PLD.MatrizCatalogoID = HIS.MatrizCatalogoID) AS MATRIZ
										WHERE Comparacion LIKE('%N%'));

		SET Var_RegDiferentes	:= IFNULL(Var_RegDiferentes, Entero_Cero);

		IF(Var_RegDiferentes>Entero_Cero) THEN
			SET Var_FolioID		:= (SELECT MAX(FolioID) FROM PLDHISMATRIZRIESGOXCONC LIMIT 1);
			SET Var_FechaActual	:= (SELECT FechaSistema FROM PARAMETROSSIS LIMIT 1);
			SET Var_FolioID		:= IFNULL(Var_FolioID, Entero_Cero)+1;
			SET Aud_FechaActual := NOW();

			INSERT INTO PLDHISMATRIZRIESGOXCONC(
				FolioID,		MatrizCatalogoID,	Tipo,				MatrizConceptoID,	Descripcion,
				Porcentaje,		LimiteInferior,		LimiteSuperior,		Orden,				TipoPersona,
				MostrarSub,		Fecha,				EmpresaID,			Usuario,			FechaActual,
				DireccionIP,	ProgramaID,			Sucursal,			NumTransaccion)
			SELECT
				Var_FolioID,	MatrizCatalogoID,	Tipo,				MatrizConceptoID,	Descripcion,
				Porcentaje,		LimiteInferior,		LimiteSuperior,		Orden,				TipoPersona,
				MostrarSub,		Var_FechaActual,	EmpresaID,			Usuario,			FechaActual,
				DireccionIP,	ProgramaID,			Sucursal,			NumTransaccion
				FROM PLDMATRIZRIESGOXCONC;
		END IF;

		SET	Par_NumErr		:= 000;
		SET	Par_ErrMen		:= CONCAT('Agregada correctamente la Configuracion de la Matriz de Riesgo.');
		SET Var_Control 	:= 'sucursalID' ;
		SET Var_Consecutivo	:= 0;

	END ManejoErrores;

	IF(Par_Salida = SalidaSi) THEN
		SELECT 	Par_NumErr AS NumErr,
		Par_ErrMen AS ErrMen,
		Var_Control AS Control,
		Var_Consecutivo AS Consecutivo;
	END IF;

END TerminaStore$$