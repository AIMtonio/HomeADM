-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- INSTITNOMINACON
DELIMITER ;
DROP PROCEDURE IF EXISTS `INSTITNOMINACON`;
DELIMITER $$


CREATE PROCEDURE `INSTITNOMINACON`(
	Par_InstitNominaID	INT(11),
	Par_ClienteID		BIGINT,
	Par_NumCon			TINYINT UNSIGNED,

	Par_EmpresaID		INT(11),
	Aud_Usuario			INT(11),
	Aud_FechaActual		DATETIME,
	Aud_DireccionIP		VARCHAR(15),
	Aud_ProgramaID		VARCHAR(50),
	Aud_Sucursal		INT(11),
	Aud_NumTransaccion	BIGINT
	)

TerminaStore: BEGIN

-- DECLARACION DE VARIABLES
DECLARE Var_InstitNominaID  VARCHAR(20);
DECLARE Var_BancoDeposito	INT(11);
DECLARE Var_CuentaDeposito	INT(11);

-- DECLARACION DE CONSTANTES
DECLARE		Con_Principal	INT(11);
DECLARE		Con_Foranea		INT(11);
DECLARE		Con_NomIns		INT(11);
DECLARE 	Con_Promotor	INT(11);
DECLARE 	Con_Banco		INT(11);
DECLARE		Con_Cte			INT(11);
DECLARE		Con_Correo		INT(11);
DECLARE		Con_NumEmpleado	INT(11);

-- ASIGNACION DE CONSTANTES
SET	Con_Principal	:= 1;
SET	Con_Foranea		:= 2;
SET	Con_NomIns		:= 3;
SET Con_Promotor	:= 4;
SET Con_Banco		:= 5;
SET Con_Cte			:= 6;
SET Con_Correo		:= 7;
SET Con_NumEmpleado	:= 8;

IF (Par_NumCon=Con_Principal) THEN

	SELECT  InstitNominaID,	NombreInstit,	ClienteID,	ContactoRH,	TelContactoRH,
            BancoDeposito,  CuentaDeposito, Estatus,    Correo,      ReqVerificacion,
            Domicilio,  ExtTelContacto,EspCtaCon,CtaContable AS NumCuentaCon,
            TipoMovID,AplicaTabla
	FROM INSTITNOMINA
	WHERE InstitNominaID = Par_InstitNominaID;
END IF;

IF (Par_NumCon=Con_Foranea) THEN
	SELECT InstitNominaID, NombreInstit
    FROM INSTITNOMINA
    WHERE InstitNominaID = Par_InstitNominaID;
 END IF;

IF (Par_NumCon=Con_NomIns) THEN
	SELECT CONCAT(CONVERT(InstitNominaID,CHAR),'-',NombreInstit)
    FROM INSTITNOMINA
    WHERE InstitNominaID = Par_InstitNominaID;
 END IF;

IF (Par_NumCon=Con_Promotor) THEN
	SELECT Prom.PromotorID, Prom.NombrePromotor, Prom.Telefono
	FROM INSTITNOMINA Ins 
    INNER JOIN CLIENTES Cli ON Ins.ClienteID=Cli.ClienteID
	INNER JOIN PROMOTORES Prom ON Cli.PromotorActual=Prom.PromotorID
	where Ins.InstitNominaID=Par_InstitNominaID;
END IF;

IF (Par_NumCon=Con_Banco) THEN
	SELECT Ins.BancoDeposito, Insti.Nombre,  Ins.CuentaDeposito
    FROM   INSTITNOMINA Ins 
    INNER JOIN INSTITUCIONES Insti ON Insti.InstitucionID=Ins.BancoDeposito
    WHERE  Ins.InstitNominaID = Par_InstitNominaID;
 END IF;
IF (Par_NumCon=Con_Cte) THEN
	SELECT  InstitNominaID,	NombreInstit
	FROM INSTITNOMINA
	WHERE ClienteID = Par_ClienteID;
END IF;

IF (Par_NumCon=Con_Correo) THEN
	SELECT  Correo
	FROM INSTITNOMINA
	WHERE InstitNominaID = Par_InstitNominaID;
END IF;

IF (Par_NumCon=Con_NumEmpleado) THEN
	SELECT INS.InstitNominaID, INS.NombreInstit, NOM.ConvenioNominaID, NOM.NoEmpleado
		FROM INSTITNOMINA INS
        INNER JOIN NOMINAEMPLEADOS NOM ON NOM.InstitNominaID=INS.InstitNominaID
		WHERE INS.Estatus = "A"
			AND NOM.ClienteID = Par_ClienteID
            AND NOM.InstitNominaID =Par_InstitNominaID;
END IF;

END TerminaStore$$