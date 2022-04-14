-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- PORCRESPERIODOLIS
DELIMITER ;
DROP PROCEDURE IF EXISTS `PORCRESPERIODOLIS`;DELIMITER $$

CREATE PROCEDURE `PORCRESPERIODOLIS`(
	-- SP creado para el registro de los porcentajes de EPRC
	Par_TipoInstit	 	VARCHAR(2),			-- Tipo de Institucion
	Par_Clasificacion   CHAR(1),			-- Clasificacion: Consumo, Comercial, Vivienda
	Par_NumLis			TINYINT UNSIGNED,	-- Numero de lista

    -- Parametros de Auditoria
	Aud_Empresa			INT(11),
	Aud_Usuario			INT(11),
	Aud_FechaActual		DATETIME,
	Aud_DireccionIP		VARCHAR(15),
	Aud_ProgramaID		VARCHAR(50),
	Aud_Sucursal		INT(11),
	Aud_NumTransaccion	BIGINT(20)
	)
TerminaStore: BEGIN
	-- Declaracion de constantes
	DECLARE	Cadena_Vacia		CHAR(1);
	DECLARE	Fecha_Vacia			DATE;
	DECLARE	Entero_Cero			INT(11);
	DECLARE	Lis_ResSofipoViv 	INT(11);
	DECLARE Lis_ReservaDias		INT(11);

    -- Asignacion de constantes
	SET	Cadena_Vacia		:= '';				-- Cadena vacia
	SET	Fecha_Vacia			:= '1900-01-01';	-- Fecha vacia
	SET	Entero_Cero			:= 0;				-- Entero Cero
	SET	Lis_ResSofipoViv	:= 1;				-- Lista Porcentajes clasificacion vivienda: SOFIPO
	SET	Lis_ReservaDias	    := 2;				-- Lista porcentajes reservas

	-- Lista Porcentajes clasificacion vivienda: SOFIPO
	IF(Par_NumLis = Lis_ResSofipoViv) THEN
			SELECT LimInferior, LimSuperior, PorResCarSReest, Entero_Cero
			FROM PORCRESPERIODO
			WHERE TipoInstitucion = Par_TipoInstit  AND Clasificacion = Par_Clasificacion;
	END IF;

	-- Lista porcentajes reservas
	IF(Par_NumLis = Lis_ReservaDias) THEN
			SELECT LimInferior, LimSuperior, PorResCarSReest,PorResCarReest
			FROM PORCRESPERIODO
			WHERE TipoInstitucion = Par_TipoInstit  AND Clasificacion = Par_Clasificacion
            ORDER BY LimInferior ASC;

	END IF;

END TerminaStore$$