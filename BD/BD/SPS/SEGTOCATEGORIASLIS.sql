-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- SEGTOCATEGORIASLIS
DELIMITER ;
DROP PROCEDURE IF EXISTS `SEGTOCATEGORIASLIS`;DELIMITER $$

CREATE PROCEDURE `SEGTOCATEGORIASLIS`(
	Par_Categoria		VARCHAR(100),
	Par_NumLis			TINYINT UNSIGNED,

    Par_EmpresaID		INT(11),
	Aud_Usuario			INT(11),
	Aud_FechaActual		DATETIME,
	Aud_DireccionIP		VARCHAR(15),
	Aud_ProgramaID		VARCHAR(50),
	Aud_Sucursal		INT(11),
	Aud_NumTransaccion	BIGINT(20)
	)
TerminaStore: BEGIN



	DECLARE Lis_Principal	INT(11);
	DECLARE Lis_Combo       INT(11);
	DECLARE Lis_CombCobra   INT(11);
	DECLARE EstatusVigente  CHAR(1);
	DECLARE CobranzaSi      CHAR(1);



	SET	Lis_Principal	:= 1;
	SET	Lis_Combo 		:= 3;
	SET	Lis_CombCobra 	:= 4;
	SET	EstatusVigente 	:= 'V';
	SET	CobranzaSi   	:= 'S';

	IF(Par_NumLis = Lis_Principal) THEN
		SELECT CategoriaID, Descripcion
			FROM SEGTOCATEGORIAS
			WHERE  Descripcion like CONCAT("%", Par_Categoria, "%")
		LIMIT 0, 15;
	END IF;

	IF(Par_NumLis = Lis_Combo) THEN
		SELECT CategoriaID, Descripcion
			FROM SEGTOCATEGORIAS
			WHERE Estatus = EstatusVigente;
	END IF;


	IF(Par_NumLis = Lis_CombCobra) THEN
		SELECT CategoriaID, Descripcion
			FROM SEGTOCATEGORIAS
			WHERE Estatus = EstatusVigente
			AND TipoCobranza = CobranzaSi;
	END IF;

END TerminaStore$$