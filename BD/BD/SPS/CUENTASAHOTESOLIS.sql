-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- CUENTASAHOTESOLIS
DELIMITER ;
DROP PROCEDURE IF EXISTS `CUENTASAHOTESOLIS`;DELIMITER $$

CREATE PROCEDURE `CUENTASAHOTESOLIS`(
# ==========================================================
# -------- SP PARA RELIZAR LISTAS DE CUENTAS BANCARIAS------
# ==========================================================
	Par_Nombre			VARCHAR(20),
	Par_IntID			INT(11),
	Par_NumLis			TINYINT UNSIGNED,

	Aud_EmpresaID		INT(11),
	Aud_Usuario			INT(11),
	Aud_FechaActual		DATETIME,
	Aud_DireccionIP		VARCHAR(15),
	Aud_ProgramaID		VARCHAR(50),
	Aud_Sucursal		INT(11),
	Aud_NumTransaccion	BIGINT(20)
)
TerminaStore: BEGIN

	-- Declaracion de Constantes
	DECLARE	Cadena_Vacia		CHAR(1);
	DECLARE	Fecha_Vacia			DATE;
	DECLARE	Entero_Cero			INT(11);
	DECLARE	Lis_Principal 		INT(11);
	DECLARE	Lis_Combo	 		INT(11);
	DECLARE	Lis_CuentaAho		INT(11);
	DECLARE Lis_NumCtaInstit  	INT(11);
	DECLARE	Lis_CuentasAhoID	INT(11);
	DECLARE Est_Activo			CHAR(1);
	DECLARE Lis_CtasChequera	INT(11);
	DECLARE Lis_CtasFondeo		INT(11);
    DECLARE Lis_NumCtaNostro	INT(11);
	DECLARE CtaConChequera		CHAR(1);

	-- Asignacion de constantes
	SET	Cadena_Vacia			:= '';			-- Cadena Vacia
	SET	Fecha_Vacia				:= '1900-01-01';-- Fecha Vacia
	SET	Entero_Cero				:= 0;			-- Entero cero
	SET	Lis_Principal			:= 1;			-- Lista Principal
	SET	Lis_CuentaAho			:= 2;  			-- Lista de Cuentas
	SET	Lis_NumCtaInstit		:= 3;			-- Lista de insituciones
	SET Lis_CuentasAhoID		:= 4;			-- Lista
	SET Lis_CtasChequera		:= 5;			-- Lista de las cuentas que manejan Chequera
	SET Lis_CtasFondeo			:= 6; 			-- Lista usada en pantalla linea de fondeo --
    SET Lis_NumCtaNostro		:= 7;			-- Lista usada en pantalla de cuentas nostro
	SET Est_Activo				:= 'A';			-- Estatus de la Instituccion Activo
	SET CtaConChequera			:= 'S';

	IF(Par_NumLis = Lis_CuentaAho) THEN

		SELECT 		cht.numCtaInstit, ch.Etiqueta, cht.SucursalInstit , cht.Saldo
			FROM 	CUENTASAHOTESO cht
					JOIN CUENTASAHO ch ON cht.CuentaAhoID=ch.CuentaAhoID
			WHERE 	cht.InstitucionID 	= Par_IntID
			AND 	(ch.Etiqueta LIKE CONCAT("%",Par_Nombre, "%")
					OR   cht.SucursalInstit LIKE CONCAT("%",Par_Nombre, "%"))
			AND 	cht.Estatus			= Est_Activo
			LIMIT 	0, 15;

	END IF;

	IF(Par_NumLis = Lis_CuentasAhoID) THEN

		SELECT 		cht.CuentaAhoID, ch.Etiqueta, cht.SucursalInstit
			FROM 	CUENTASAHOTESO cht
					JOIN CUENTASAHO ch ON cht.CuentaAhoID=ch.CuentaAhoID
			WHERE 	cht.InstitucionID 	= Par_IntID
			AND 	ch.Etiqueta LIKE CONCAT("%",Par_Nombre, "%")
			AND 	cht.Estatus			= Est_Activo
			LIMIT 	0, 15;

	END IF;


	IF (Par_NumLis = Lis_NumCtaInstit)THEN

		SELECT 		cht.NumCtaInstit, cht.SucursalInstit
			FROM 	CUENTASAHOTESO cht
					JOIN CUENTASAHO ch ON cht.CuentaAhoID=ch.CuentaAhoID
			WHERE 	cht.InstitucionID	= Par_IntID
			AND 	ch.Etiqueta LIKE CONCAT("%",Par_Nombre, "%")
			AND 	cht.Estatus			= Est_Activo
			LIMIT 0, 15;

	END IF;

	IF (Par_NumLis = Lis_CtasChequera)THEN
		SELECT 		cht.NumCtaInstit, cht.SucursalInstit
			FROM 	CUENTASAHOTESO cht
					JOIN CUENTASAHO ch ON cht.CuentaAhoID=ch.CuentaAhoID
			WHERE 	cht.Chequera 		= 'S' -- No se puede poner una constante con valor 'S' error 1267
			AND 	cht.InstitucionID 	= Par_IntID
			AND 	cht.Estatus 		= Est_Activo
            AND 	cht.NumCtaInstit LIKE CONCAT("%",Par_Nombre, "%")
			LIMIT 	0, 15;
	END IF;

	IF (Par_NumLis = Lis_CtasFondeo)THEN
		SELECT 		cht.NumCtaInstit, cht.SucursalInstit
			FROM 	CUENTASAHOTESO cht
					JOIN CUENTASAHO ch ON cht.CuentaAhoID=ch.CuentaAhoID
			WHERE 	cht.InstitucionID 	= Par_IntID
			AND 	cht.SucursalInstit LIKE CONCAT("%",Par_Nombre,"%")
			AND 	cht.Estatus			= Est_Activo
			LIMIT 0, 15;
	END IF;


	IF (Par_NumLis = Lis_NumCtaNostro)THEN

		SELECT 		cht.NumCtaInstit, cht.SucursalInstit
			FROM 	CUENTASAHOTESO cht
					JOIN CUENTASAHO ch ON cht.CuentaAhoID=ch.CuentaAhoID
			WHERE 	cht.InstitucionID	= Par_IntID
			AND 	cht.NumCtaInstit LIKE CONCAT("%",Par_Nombre, "%")
			AND 	cht.Estatus			= Est_Activo
			LIMIT 0, 15;

	END IF;

END TerminaStore$$