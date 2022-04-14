-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- DISPERSIONCON
DELIMITER ;
DROP PROCEDURE IF EXISTS `DISPERSIONCON`;
DELIMITER $$


CREATE PROCEDURE `DISPERSIONCON`(
	Par_FolioOperacion 	INT(11),
	Par_NumCon			TINYINT UNSIGNED,

	Aud_EmpresaID		INT(11),
	Aud_Usuario			INT(11),
	Aud_FechaActual		DATETIME,
	Aud_DireccionIP		VARCHAR(15),
	Aud_ProgramaID		VARCHAR(50),
	Aud_Sucursal		INT(11),
	Aud_NumTransaccion	BIGINT(20)
)

TerminaStore: BEGIN
	-- Declaracion de variables
	DECLARE ContDispTrans				INT(11);	-- Cantidad de dispersiones por transferencia
	DECLARE ContDispOrdpag				INT(11);	-- Cantidad de dispersiones por orden de pagos
	DECLARE	Var_TipoTransSanta			VARCHAR(4);	-- Tipo Transferencias Santander

	-- Declaracion de constantes
	DECLARE	Entero_Cero	   				INT(11);
	DECLARE	Con_DisperConsec			INT(11);
	DECLARE Con_Principal     			INT(11);
	DECLARE Con_DispersionAutorizada	INT(11);
	DECLARE	Con_NumTransaccion			INT(11);
	DECLARE	Con_DispTransOrderPag		INT(11);		-- Dispersion de transferencias y dispersion de orden de pago
	DECLARE Con_DispTransSanta			VARCHAR(50);	-- Llave parametro para el tipo de movimiento contable de Transferecnias Santander
	-- Asignacion de constantes
	SET Con_DisperConsec 			:=	4;
	SET Con_Principal    			:=	1;
	SET Con_DispersionAutorizada	:=	5;
	SET Con_NumTransaccion			:=	7;
	SET Con_DispTransOrderPag		:=	8;

    SET Con_DispTransSanta		:= 'DispTransSantander';


    SELECT ValorParametro INTO Var_TipoTransSanta
		FROM PARAMGENERALES
		WHERE LlaveParametro=Con_DispTransSanta;

    SET Var_TipoTransSanta := IFNULL(Var_TipoTransSanta, '');

	IF(Par_NumCon = Con_DisperConsec) THEN
		SELECT MAX((FolioOperacion)+1) FROM DISPERSION;
	END IF;


	IF(Par_NumCon = Con_Principal) THEN

	SELECT T.NumCtaInstit AS CuentaAhoID, D.FechaOperacion,D.InstitucionID,D.Estatus
		FROM CUENTASAHOTESO T
		INNER JOIN DISPERSION D ON T.NumCtaInstit = D.NumCtaInstit
		WHERE D.FolioOperacion = Par_FolioOperacion;
	END IF;


	IF(Par_NumCon = Con_DispersionAutorizada) THEN
		SELECT cat.NumCtaInstit AS CuentaAhoID,d.FechaOperacion,d.InstitucionID,dm.Estatus
		FROM DISPERSION d
		INNER JOIN DISPERSIONMOV dm
		ON d.FolioOperacion=dm.DispersionID AND dm.TipoMovDIspID IN('2','3','5','15','21','22','103','700', Var_TipoTransSanta,'708','709')
		INNER JOIN CUENTASAHOTESO cat
		ON d.CuentaAhoID=cat.CuentaAhoID
		WHERE d.FolioOperacion=Par_FolioOperacion;
	END IF;

	IF(Par_NumCon = Con_NumTransaccion) THEN
		SELECT NumTransaccion
			FROM DISPERSION
			WHERE FolioOperacion=Par_FolioOperacion;

	END IF;

	IF(Par_NumCon = Con_DispTransOrderPag) THEN
		SELECT	COUNT(dm.TipoMovDIspID) INTO ContDispTrans
			FROM DISPERSIONMOV dm
			INNER JOIN DISPERSION d	ON dm.DispersionID=d.FolioOperacion
			WHERE dm.DispersionID=	Par_FolioOperacion
			AND 	dm.FormaPago = 6
			LIMIT 1;

		SELECT	COUNT(dm.TipoMovDIspID) INTO ContDispOrdpag
			FROM DISPERSIONMOV dm
			INNER JOIN DISPERSION d	ON dm.DispersionID=d.FolioOperacion
			WHERE dm.DispersionID=	Par_FolioOperacion
			AND 	dm.FormaPago = 5
			LIMIT 1;

		SELECT ContDispTrans, ContDispOrdpag;

	END IF;


END TerminaStore$$