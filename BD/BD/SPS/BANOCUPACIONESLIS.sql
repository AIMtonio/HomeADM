-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- BANOCUPACIONESLIS
DELIMITER ;
DROP PROCEDURE IF EXISTS `BANOCUPACIONESLIS`;
DELIMITER $$


CREATE PROCEDURE `BANOCUPACIONESLIS`(
	Par_Descripcion	VARCHAR(100),				-- Descrpcion de la OCUPACIONES
	Par_NumLis		TINYINT UNSIGNED,			-- Numero de lista
	
    Aud_EmpresaID		INT, 					-- Auditoria
	Aud_Usuario			INT,					-- Auditoria
	Aud_FechaActual		DATETIME,				-- Auditoria
	Aud_DireccionIP		VARCHAR(15),			-- Auditoria
	Aud_ProgramaID		VARCHAR(50),			-- Auditoria
	Aud_Sucursal		INT,					-- Auditoria
	Aud_NumTransaccion	BIGINT					-- Auditoria
	)

TerminaStore: BEGIN

DECLARE		Cadena_Vacia	CHAR(1);			-- Cadena vacia
DECLARE		Fecha_Vacia		DATE;				-- Fecha vacia
DECLARE		Entero_Cero		INT;				-- Entero cero
DECLARE		Lis_Principal	INT;				-- Consulta lista principal

Set	Cadena_Vacia	:= '';
Set	Fecha_Vacia		:= '1900-01-01';
Set	Entero_Cero		:= 0;
Set	Lis_Principal	:= 1;

IF(Par_NumLis = Lis_Principal) THEN
	SELECT	`OcupacionID`,		`Descripcion`
	FROM OCUPACIONES;
END IF;

END TerminaStore$$ 
