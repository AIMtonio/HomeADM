-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- CATALOGOSERVCON
DELIMITER ;
DROP PROCEDURE IF EXISTS `CATALOGOSERVCON`;
DELIMITER $$


CREATE PROCEDURE `CATALOGOSERVCON`(



	Par_CatalogoSerID	INT(11),
	Par_NumCon			TINYINT UNSIGNED,

	Par_EmpresaID		INT(11),
	Aud_Usuario			INT(11),
	Aud_FechaActual		DATETIME,
	Aud_DireccionIP		VARCHAR(15),
	Aud_ProgramaID		VARCHAR(50),
	Aud_Sucursal		INT(11),
	Aud_NumTransaccion	BIGINT
		)

TerminaStore:BEGIN


	DECLARE Con_Principal		INT;
	DECLARE Con_MontoServicio	INT;
    DECLARE BancaMovilSi		CHAR(1);
	DECLARE BancaMovilNo		CHAR(1);


	SET Con_Principal			:= 1;
	SET Con_MontoServicio 		:= 2;
	SET BancaMovilSi			:= 'S';
	SET BancaMovilNo			:= 'N';

	IF (Par_NumCon = Con_Principal) THEN
		SELECT	CatalogoServID,	Origen,			NombreServicio,		RazonSocial,		Direccion,
				CobraComision,	MontoComision,	CtaContaCom,		CtaContaIVACom,		CtaPagarProv,
				MontoServicio,	CtaContaServ,	CtaContaIVAServ,	RequiereCliente,	RequiereCredito,
				BancaElect,		PagoAutomatico,	CuentaClabe, 		CCostosServicio,	NumServProve,
                Ventanilla,		BancaMovil,		Estatus
			FROM CATALOGOSERV
			WHERE	CatalogoServID =Par_CatalogoSerID;
	END IF;

	IF(Par_NumCon = Con_MontoServicio) THEN
		SELECT	MontoComision,	MontoServicio,	Origen
			FROM CATALOGOSERV
            WHERE	CatalogoServID	= Par_CatalogoSerID;
	END IF;

END TerminaStore$$