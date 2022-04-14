-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- APORTASOCSEGVIDREP
DELIMITER ;
DROP PROCEDURE IF EXISTS `APORTASOCSEGVIDREP`;DELIMITER $$

CREATE PROCEDURE `APORTASOCSEGVIDREP`(
    Par_ClienteID       int(11),
    Par_NumCon          tinyint unsigned,

    Par_EmpresaID       int(11),
    Aud_Usuario         int(11),
    Aud_FechaActual     datetime,
    Aud_DireccionIP     varchar(15),
    Aud_ProgramaID      varchar(50),
    Aud_Sucursal        int(11),
    Aud_NumTransaccion  bigint(20)
	)
TerminaStore: BEGIN

DECLARE Var_MontoSeguro   decimal(14,2);
DECLARE Var_Aportacion  char(1);
DECLARE Var_SegClienteID     int(11);
DECLARE MontoLetra      varchar(200);
DECLARE Var_Vigente     char(1);

DECLARE Cadena_Vacia    char(1);
DECLARE Fecha_Vacia     date;
DECLARE Var_FechaSis    date;
DECLARE Entero_Cero     int;
DECLARE Con_Principal   int;
DECLARE Dir_Oficial     char(1);
DECLARE Seccion_Benefi  int;
DECLARE Cue_Activa      char(1);
DECLARE Es_Beneficiario char(1);
DECLARE Var_Principal   char(1);


Set Cadena_Vacia        := '';
Set Fecha_Vacia         := '1900-01-01';
Set Entero_Cero         := 0;
Set Con_Principal       := 1;
Set Seccion_Benefi      := 2;
Set Var_Aportacion      := 'A';
Set Dir_Oficial         := 'S';
Set Es_Beneficiario     := 'S';
Set Cue_Activa          := 'A';
Set Var_Vigente         := 'V';
Set Var_Principal       := 'S';

IF(Par_NumCon = Con_Principal) THEN

SELECT FechaSistema INTO Var_FechaSis
		from	PARAMETROSSIS;

SELECT max(SeguroClienteID) INTO Var_SegClienteID
       FROM SEGUROCLIENTE
       where ClienteID = Par_ClienteID
       and Estatus  =  Var_Vigente;

SELECT MontoSegPagado INTO Var_MontoSeguro
        FROM SEGUROCLIENTE
        WHERE ClienteID = Par_ClienteID
        AND SeguroClienteID = Var_SegClienteID;


Set MontoLetra := FUNCIONNUMLETRAS(Var_MontoSeguro);
SELECT FORMAT(round(Var_MontoSeguro,2),2) AS TotMonto,MontoLetra,Var_FechaSis;

end if;



IF(Par_NumCon = Seccion_Benefi) THEN

select Per.CuentaAhoID as Cuenta, Per.NombreCompleto, Tip.Descripcion as Relacion, ROUND(Per.Porcentaje,4) as Porcentaje,
           Per.FechaNac, Per.TelefonoCasa, Per.TelefonoCelular,Per.Domicilio,Tip.Descripcion
        from CUENTASAHO Cue,
             CUENTASPERSONA Per,
             TIPORELACIONES Tip
        where Cue.ClienteID = Par_ClienteID
          and Cue.Estatus = Cue_Activa
          and Cue.EsPrincipal = Var_Principal
          and Cue.CuentaAhoID = Per.CuentaAhoID
          and Per.EstatusRelacion = Var_Vigente
		  and Per.EsBeneficiario = Es_Beneficiario
          and Per.ParentescoID = Tip.TipoRelacionID;
END IF;

END TerminaStore$$