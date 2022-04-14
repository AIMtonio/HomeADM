-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- SEGTOADMONGESTORLIS
DELIMITER ;
DROP PROCEDURE IF EXISTS `SEGTOADMONGESTORLIS`;DELIMITER $$

CREATE PROCEDURE `SEGTOADMONGESTORLIS`(
	Par_GestorID		INT(11),
	Par_TipoGestionID	VARCHAR(20),
	Par_NumLis			TINYINT UNSIGNED,

	Par_EmpresaID		INT(11),
	Aud_Usuario			INT(11),
	Aud_FechaActual		DATETIME,
	Aud_DireccionIP		VARCHAR(15),
	Aud_ProgramaID		VARCHAR(50),
	Aud_Sucursal       	INT(11),
	Aud_NumTransaccion	BIGINT(20)
	)
TerminaStore: BEGIN

	/*Declaracion de Constantes*/
	DECLARE	Cadena_Vacia    CHAR(1);
	DECLARE	Entero_Cero     INT;
	DECLARE EstatusActivo   CHAR(1);
	DECLARE EstatusVigente  CHAR(1);
	DECLARE	Lis_TipoGestor  INT(11);
	DECLARE Tipo_Gestor		INT(11);
	DECLARE Sup_Gestor		INT(11);

	/*Asignacion de Constantes*/
	SET Cadena_Vacia    := ''; 			-- Cadena vacia
	SET Entero_Cero     := 0;			-- Entero en cero
	SET EstatusActivo   := 'A';         -- Estatus Activo
	SET EstatusVigente  := 'V';
	SET	Lis_TipoGestor  := 2;           -- Lista de Tipos de Gestores por Gestor
	SET Tipo_Gestor		:= 3;
	SET Sup_Gestor		:= 4;


	-- Lista de Tipos de Gestion por Gestor
	IF(Par_NumLis = Lis_TipoGestor) THEN
		SELECT	Tip.TipoGestionID,Tip.Descripcion,Usu.UsuarioID
	FROM	TIPOGESTION Tip,
			USUARIOS Usu,
			PUESTOS Ps
		WHERE	Usu.UsuarioID = Par_GestorID
			AND	Ps.TipoGestorID	= Tip.TipoGestionID
			AND Usu.Estatus		= EstatusActivo
			AND Tip.Estatus		= EstatusActivo
			AND Ps.Estatus 		= EstatusVigente
			AND (Tip.Descripcion LIKE CONCAT('%',Par_TipoGestionID, '%'))
		GROUP BY Tip.TipoGestionID, Tip.Descripcion, Usu.UsuarioID
		LIMIT 0, 15;
	END IF;


	IF(Par_NumLis = Tipo_Gestor) THEN
	--  lista de Tipo de Gestion que filtra segun el gestor seleccionado
	SELECT seg.TipoGestionID, tip.Descripcion
		FROM SEGTOADMONGESTOR seg
		INNER JOIN TIPOGESTION tip
		ON tip.TipoGestionID = seg.TipoGestionID
		WHERE seg.GestorID = Par_GestorID
		AND tip.Estatus = EstatusActivo; -- par_gestor
	END IF;

	IF(Par_NumLis =  Sup_Gestor) THEN
	-- lista Supervisor segun gestor y tipo de gestion --
	SELECT seg.SupervisorID,usu.NombreCompleto
		FROM SEGTOADMONGESTOR seg
		INNER JOIN USUARIOS usu
		ON usu.UsuarioID = seg.SupervisorID
		WHERE seg.GestorID = Par_GestorID
		AND seg.TipoGestionID = Par_TipoGestionID;
	END IF;


END TerminaStore$$