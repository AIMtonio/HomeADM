-- SP NOMCLAVEPRESUPLIS

DELIMITER ;

DROP PROCEDURE IF EXISTS NOMCLAVEPRESUPLIS;

DELIMITER $$

CREATE  PROCEDURE NOMCLAVEPRESUPLIS(
	-- SP para  listar los Claves Presupuestales
	Par_NomClavePresupID		INT(11),			-- Numero o Id del Clave Presupuestal
	Par_NumLis					TINYINT UNSIGNED,	-- Numero de consulta de la lista

	-- Parametros de Auditoria
	Aud_EmpresaID				INT(11),			-- ID de la Empresa
	Aud_Usuario					INT(11),			-- ID del Usuario que creo el Registro
	Aud_FechaActual				DATETIME,			-- Fecha Actual de la creacion del Registro
	Aud_DireccionIP				VARCHAR(15),		-- Direccion IP de la computadora
	Aud_ProgramaID				VARCHAR(50),		-- Identificador del Programa
	Aud_Sucursal				INT(11),			-- Identificador de la Sucursal
	Aud_NumTransaccion			BIGINT(20)			-- Numero de Transaccion
)TerminaStore: BEGIN
	-- Declaracion de constantes
	DECLARE Cadena_Vacia			CHAR(1);		-- Cadena vacia
	DECLARE Lis_ClavPresup			INT(11);		-- Variable para la lista de los claves presupuestales registrado
	DECLARE Lis_ClavPresupComb		INT(11);		-- Variable para la lista de los claves presupuestales registrado Combo
	DECLARE Lis_ClavPresupConvGrid	INT(11);		-- Variable para la lista de los claves presupuestales registrado para el grid


	-- Asignacion de constantes
	SET	Cadena_Vacia			:= '';				-- Asignacion de Cadena Vacia
	SET	Lis_ClavPresup			:= 1;				-- Variable para la lista de los claves presupuestales registrado
	SET Lis_ClavPresupComb		:= 2;				-- Variable para la lista de los claves presupuestales registrado Combo
	SET Lis_ClavPresupConvGrid	:= 3;				-- Variable para la lista de los claves presupuestales registrado para el grid


	-- 1.- Variable para la lista de los claves presupuestales registrado
	IF(Par_NumLis = Lis_ClavPresup) THEN
		SELECT CLAV.NomClavePresupID,		CLAV.NomTipoClavePresupID,			CLAV.Clave,			CLAV.Descripcion,		IFNULL(CLASICLAV.NomClasifClavPresupID,0) AS NomClasifClavPresupID
			FROM NOMCLAVEPRESUP CLAV
			LEFT JOIN NOMCLASIFCLAVEPRESUP CLASICLAV ON FIND_IN_SET(CLAV.NomClavePresupID, CLASICLAV.NomClavePresupID)
			ORDER BY CLAV.FechaActual, CLAV.NomClavePresupID DESC;
	END IF;

	-- 2.- Numero de lista de los claves presupuestales registrado para el combo
	IF(Par_NumLis = Lis_ClavPresupComb) THEN
		SELECT NomClavePresupID,	CONCAT(IFNULL(Clave, Cadena_Vacia), "-",Descripcion) AS Descripcion
			FROM NOMCLAVEPRESUP;
	END IF;

	-- 3.- Numero de lista de los claves presupuestales registrado para el combo de la pantalla de clave por convenio
	IF(Par_NumLis = Lis_ClavPresupConvGrid) THEN
		SELECT NomClavePresupID,	Clave,			Descripcion
			FROM NOMCLAVEPRESUP;
	END IF;

END TerminaStore$$

