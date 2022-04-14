-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- PLDDETECGAFICON
DELIMITER ;
DROP PROCEDURE IF EXISTS `PLDDETECGAFICON`;DELIMITER $$

CREATE PROCEDURE `PLDDETECGAFICON`(
/*SP QUE ES LLAMADO DESDE PANTALLA PARA LA DETECCION DE PERSONAS CON PAISES EN EL CATALOGO DE LA GAFI*/
	Par_ClavePersonaInv		INT(11),		# Numero de Cliente o Usuario de Servicios Modificado, cero si es en el alta
	Par_PaisID				INT(11),		# ID del Pais
	Par_PrimerNombre		VARCHAR(50),	# Primer Nombre
	Par_SegundoNombre		VARCHAR(50),	# Segundo Nombre
	Par_TercerNombre		VARCHAR(50),	# Tercer Nombre
	Par_ApellidoPaterno		VARCHAR(50),	# Apellido Paterno
	Par_ApellidoMaterno		VARCHAR(50),	# Apellido Materno
	Par_TipoPersona			CHAR(1),		# F. Fisica A. Fisica con Act Empresarial M. Moral
	Par_RazonSocial			VARCHAR(150),	# Razon social
	Par_TipoPersSAFI		VARCHAR(3),		# CTE. Cliente USU. Usuario de Servicios AVA Aval PRO NA. No Aplica

	/* Parametros de Auditoria */
	Par_EmpresaID			INT(11),
	Aud_Usuario				INT(11),

	Aud_FechaActual			DATETIME,
	Aud_DireccionIP			VARCHAR(15),
	Aud_ProgramaID			VARCHAR(50),
	Aud_Sucursal			INT(11),
	Aud_NumTransaccion		BIGINT(20)
		)
TerminaStore: BEGIN
	-- Declaracion de Constantes
	DECLARE	Cadena_Vacia			CHAR(1);				# Cadena Vacia
	DECLARE	Fecha_Vacia				DATE;					# Fecha Vacia
	DECLARE	Entero_Cero				INT;					# Entero Cero
	DECLARE Cons_Si					CHAR(1);				# Constante SI
	DECLARE Cons_No					CHAR(1);				# Constante No
	-- Declaracion de Variables
	DECLARE Var_NumErr				INT(11);
	DECLARE Var_ErrMen				VARCHAR(400);
	DECLARE Var_Control				VARCHAR(50);
	DECLARE Var_TipoPais			CHAR(1);
	DECLARE Var_NombrePais			VARCHAR(100);

	-- Asignacion de Constantes
	SET	Cadena_Vacia				:= '';				-- Cadena vacia
	SET	Fecha_Vacia					:= '1900-01-01';	-- Fecha vacia
	SET	Entero_Cero					:= 0;				-- Entero Cero
	SET Cons_No						:= 'N';				-- Constante No
	SET Cons_Si						:= 'S';				-- Constante Si

	SELECT TipoPais INTO Var_TipoPais
		FROM CATPAISESGAFI
			WHERE PaisID = Par_PaisID;

	CALL PLDDETECGAFIPRO(
		Par_ClavePersonaInv,		Par_PaisID,				Par_PrimerNombre,		Par_SegundoNombre,		Par_TercerNombre,
		Par_ApellidoPaterno,		Par_ApellidoMaterno,	Par_TipoPersona,		Par_RazonSocial,		Par_TipoPersSAFI,
		Cons_No,					Var_NumErr,				Var_ErrMen,				Par_EmpresaID,			Aud_Usuario,
		Aud_FechaActual,			Aud_DireccionIP,		Aud_ProgramaID,			Aud_Sucursal,			Aud_NumTransaccion);

	IF(Var_NumErr != Entero_Cero) THEN
		SET Var_NombrePais :=(SELECT Nombre FROM PAISES WHERE PaisID = Par_PaisID);
		SET Var_NombrePais := IFNULL(Var_NombrePais, Cadena_Vacia);
		SELECT Cons_Si AS EstaEnCatalogo, Var_TipoPais AS TipoPais, Var_NombrePais AS Nombre;
	 ELSE
		SELECT Cons_No AS EstaEnCatalogo, Cadena_Vacia AS TipoPais, Cadena_Vacia AS Nombre;
	END IF;

END TerminaStore$$