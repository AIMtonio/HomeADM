-- SP NOMTIPOCLAVEPRESUPLIS

DELIMITER ;

DROP PROCEDURE IF EXISTS NOMTIPOCLAVEPRESUPLIS;

DELIMITER $$

CREATE  PROCEDURE NOMTIPOCLAVEPRESUPLIS(
	-- SP para  listar los tipos de Claves Presupuestales
	Par_NomTipoClavePresupID	INT(11),			-- Numero o Id del tipo Clave Presupuestal
	Par_Descripcion				VARCHAR(80),		-- Indica el tipo de clave presupuestal
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
	DECLARE Lis_TipoClavPresup		INT(11);		-- Variable para la lista de los tipos de claves presupuestales registrado
	DECLARE Lis_ComboTipoClave		INT(11);		-- Variable para la lista de combos de los tipos de claves presupuestales registrado

	-- Asignacion de constantes
	SET	Lis_TipoClavPresup			:= 1;			-- Variable para la lista de los tipos de claves presupuestales registrado
	SET Lis_ComboTipoClave			:= 2;			-- Variable para la lista de combos de los tipos de claves presupuestales registrado

	-- 1.- Variable para la lista de los tipos de claves presupuestales registrado
	IF(Par_NumLis = Lis_TipoClavPresup) THEN
		SELECT NomTipoClavePresupID,		Descripcion
			FROM NOMTIPOCLAVEPRESUP
			WHERE Descripcion LIKE CONCAT("%", Par_Descripcion, "%")
			LIMIT 0,15;
	END IF;

	-- 2.- Variable para la lista de combos de los tipos de claves presupuestales registrado
	IF(Par_NumLis = Lis_ComboTipoClave) THEN
		SELECT NomTipoClavePresupID,		Descripcion
			FROM NOMTIPOCLAVEPRESUP;
	END IF;

END TerminaStore$$
