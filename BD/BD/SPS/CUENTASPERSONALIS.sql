-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- CUENTASPERSONALIS
DELIMITER ;
DROP PROCEDURE IF EXISTS `CUENTASPERSONALIS`;
DELIMITER $$


CREATE PROCEDURE `CUENTASPERSONALIS`(
    Par_CuentaAhoID     BIGINT(12),
    Par_NombreComp      VARCHAR(100),
    Par_NumLis          TINYINT UNSIGNED,

    Aud_EmpresaID       INT,
    Aud_Usuario         INT,
    Aud_FechaActual     DATETIME,
    Aud_DireccionIP     VARCHAR(15),
    Aud_ProgramaID      VARCHAR(50),
    Aud_Sucursal        INT,
    Aud_NumTransaccion  BIGINT
        )

TerminaStore: BEGIN

DECLARE     Cadena_Vacia        CHAR(1);
DECLARE     Fecha_Vacia         DATE;
DECLARE     Entero_Cero         INT;
DECLARE     Lis_Principal       INT;
DECLARE     Lis_Firmante        INT;
DECLARE     Lis_Apoderado       INT;
DECLARE     Lis_Firmante2       INT;
DECLARE     Lis_Cotitulares     INT;
DECLARE     Lis_Beneficiarios   INT;
DECLARE     Lis_APortContrato   INT;
DECLARE     Lis_Relacionados    INT;
DECLARE     Firmante            CHAR(1);
DECLARE     IndetificAp         VARCHAR(20);
DECLARE     Vigente             CHAR(1);
DECLARE     Var_Si          CHAR(1);
DECLARE     Apoderado           VARCHAR(9);
DECLARE     Titular             VARCHAR(7);
DECLARE     Cotitular           VARCHAR(9);
DECLARE     Beneficiario        VARCHAR(12);
DECLARE     ProvRecursos        VARCHAR(21);
DECLARE     PropReal            VARCHAR(16);
DECLARE     EsFirmante          VARCHAR(8);


SET Cadena_Vacia        := '';
SET Fecha_Vacia         := '1900-01-01';
SET Entero_Cero         := 0;
SET Lis_Principal       := 1;
SET Lis_Firmante        := 2;
SET Lis_Apoderado       := 3;
SET Lis_Firmante2       := 4;
SET Lis_Cotitulares     := 5;
SET Lis_Beneficiarios   := 6;
SET Lis_APortContrato   := 7;
SET Lis_Relacionados    := 8;
SET Firmante            := 'S';
SET Vigente             := 'V';
SET Var_Si          := 'S';
SET Apoderado           :='APODERADO';
SET Titular             :='TITULAR';
SET Cotitular           :='COTITULAR';
SET Beneficiario        :='BENEFICIARIO';
SET ProvRecursos        :='PROVEEDOR DE RECURSOS';
SET PropReal            :='PROPIETARIO REAL';
SET EsFirmante          :='FIRMANTE';

IF(Par_NumLis = Lis_Principal) THEN
    SELECT PersonaID, NombreCompleto
        FROM CUENTASPERSONA
        WHERE  CuentaAhoID = Par_CuentaAhoID
        AND NombreCompleto LIKE CONCAT("%", Par_NombreComp, "%")
        AND EstatusRelacion = Vigente
    LIMIT 0, 15;
END IF;

IF(Par_NumLis = Lis_Firmante) THEN
    SELECT  CUENTASPERSONA.PersonaID,   IFNULL(CUENTASPERSONA.NombreCompleto, CUENTASPERSONA.PrimerNombre),  CUENTASFIRMA.Tipo,  CUENTASFIRMA.InstrucEspecial
        FROM        CUENTASPERSONA
        LEFT OUTER JOIN CUENTASFIRMA
            ON  CUENTASPERSONA.PersonaID = CUENTASFIRMA.PersonaID
            AND     CUENTASPERSONA.CuentaAhoID = CUENTASFIRMA.CuentaAhoID
        WHERE   CUENTASPERSONA.CuentaAhoID      = Par_CuentaAhoID
            AND CUENTASPERSONA.EsFirmante       = Firmante
            AND CUENTASPERSONA.EstatusRelacion  = Vigente;
END IF;


if(Par_NumLis = Lis_Apoderado) then
    SELECT      CUENTASPERSONA.CuentaAhoID, CUENTASPERSONA.NombreCompleto,  TIPOSIDENTI.Nombre as TipoIdentiID, CUENTASPERSONA.PuestoA
        FROM    CUENTASPERSONA
        LEFT OUTER JOIN TIPOSIDENTI
                ON  CUENTASPERSONA.TipoIdentiID = TIPOSIDENTI.TipoIdentiID
        WHERE           CUENTASPERSONA.CuentaAhoID  = Par_CuentaAhoID
        AND         CUENTASPERSONA.EstatusRelacion  = Vigente
        AND         CUENTASPERSONA.EsApoderado      = 'S';
END IF;

IF(Par_NumLis = Lis_Firmante2) THEN
    SELECT      CUENTASPERSONA.CuentaAhoID,     CUENTASPERSONA.NombreCompleto,
                CUENTASPERSONA.EsFirmante,  TIPOSIDENTI.Nombre as TipoIdentiID
    FROM            CUENTASPERSONA
         LEFT OUTER JOIN TIPOSIDENTI
            ON  CUENTASPERSONA.TipoIdentiID = TIPOSIDENTI.TipoIdentiID
    WHERE           CUENTASPERSONA.CuentaAhoID  = Par_CuentaAhoID
    AND         CUENTASPERSONA.EstatusRelacion  = Vigente
    AND         CUENTASPERSONA.EsFirmante       = Firmante;
END IF;

IF(Par_NumLis = Lis_Cotitulares) THEN
    SELECT      CUENTASPERSONA.CuentaAhoID,     CUENTASPERSONA.NombreCompleto,
                CUENTASPERSONA.EsCotitular,     TIPOSIDENTI.Nombre as TipoIdentiID
    FROM            CUENTASPERSONA
         LEFT OUTER JOIN TIPOSIDENTI
            ON  CUENTASPERSONA.TipoIdentiID = TIPOSIDENTI.TipoIdentiID

    WHERE           CUENTASPERSONA.CuentaAhoID  = Par_CuentaAhoID
    AND         CUENTASPERSONA.EstatusRelacion  = Vigente
    AND         CUENTASPERSONA.EsCotitular      = Var_Si;
END IF;

IF(Par_NumLis = Lis_Beneficiarios) THEN
    SELECT      Cta.CuentaAhoID,    Cta.NombreCompleto, Cta.Porcentaje,
                Tre.Descripcion as  DescripParentesco
    FROM        CUENTASPERSONA Cta
    LEFT  JOIN TIPORELACIONES Tre
            ON  Cta.ParentescoID = Tre.TipoRelacionID

    WHERE       Cta.CuentaAhoID         = Par_CuentaAhoID
    AND         Cta.EstatusRelacion     = Vigente
    AND         Cta.EsBeneficiario      = Var_Si;

END IF;

IF(Par_NumLis = Lis_APortContrato) THEN
    SELECT      CuentaAhoID,    NombreCompleto, RFC,        FechaNac,       Domicilio
    FROM            CUENTASPERSONA
    WHERE       CuentaAhoID     = Par_CuentaAhoID
    AND         EstatusRelacion = Vigente
    AND         EsApoderado     = Var_Si;
END IF;


IF(Par_NumLis = Lis_Relacionados) THEN
    (SELECT ctap.CuentaAhoID,   cta.ClienteID,  cte.NombreCompleto, ctap.PaisNacimiento,    ctap.FechaNac,
            IFNULL(ctap.CURP,Cadena_Vacia) AS CURP, IFNULL(ctap.RFC, Cadena_Vacia) AS RFC,ctap.OcupacionID, IFNULL(pai.Nombre,Cadena_Vacia) as NombrePais,
            IFNULL(ocu.Descripcion,Cadena_Vacia) AS Ocupacion,
            concat( IF(ctap.EsApoderado=Var_Si,Apoderado,''),' ',
                    IF(ctap.EsTitular=Var_Si,Titular,''),' ',
                    IF(ctap.EsCotitular=Var_Si,Cotitular,''),' ',
                    IF(ctap.EsBeneficiario=Var_Si,Beneficiario,''),' ',
                    IF(ctap.EsProvRecurso=Var_Si,ProvRecursos,''),' ',
                    IF(ctap.EsPropReal=Var_Si,PropReal,''),' ',
                    IF(ctap.EsFirmante=Var_Si,EsFirmante,'')
                )AS TipoPersona
        FROM CUENTASPERSONA ctap
        INNER JOIN CUENTASAHO cta on ctap.CuentaAhoID = cta.CuentaAhoID
        INNER JOIN CLIENTES cte on cta.ClienteID = cte.ClienteID
        INNER JOIN PAISES pai   on ctap.PaisNacimiento = pai.PaisID
        LEFT JOIN OCUPACIONES ocu on ctap.OcupacionID = ocu.OcupacionID
        WHERE ctap.NombreCompleto = Par_NombreComp
            AND  IFNULL(ctap.clienteID,0)<=0)
    UNION
    (SELECT ctap.CuentaAhoID,   cta.ClienteID,  cte.NombreCompleto, ctap.PaisNacimiento,    cter.FechaNacimiento,
            IFNULL(cter.CURP,Cadena_Vacia) AS CURP, IFNULL(cter.RFC, Cadena_Vacia) AS RFC,  cter.OcupacionID,
            IFNULL(pai.Nombre,Cadena_Vacia) AS NombrePais,  IFNULL(ocu.Descripcion,Cadena_Vacia) AS Ocupacion,
            CONCAT( IF(ctap.EsApoderado=Var_Si,Apoderado,''),' ',
                    IF(ctap.EsTitular=Var_Si,Titular,''),' ',
                    IF(ctap.EsCotitular=Var_Si,Cotitular,''),' ',
                    IF(ctap.EsBeneficiario=Var_Si,Beneficiario,''),' ',
                    IF(ctap.EsProvRecurso=Var_Si,ProvRecursos,''),' ',
                    IF(ctap.EsPropReal=Var_Si,PropReal,''),' ',
                    IF(ctap.EsFirmante=Var_Si,EsFirmante,'')
                )AS TipoPersona
        FROM CUENTASPERSONA ctap
        INNER JOIN CUENTASAHO cta on ctap.CuentaAhoID = cta.CuentaAhoID
        INNER JOIN CLIENTES cte on cta.ClienteID = cte.ClienteID
        INNER JOIN CLIENTES cter on ctap.ClienteID = cter.ClienteID
        INNER JOIN PAISES pai   on cte.LugarNacimiento = pai.PaisID
        LEFT JOIN OCUPACIONES ocu on cter.OcupacionID = ocu.OcupacionID
        WHERE ctap.NombreCompleto = Par_NombreComp
            and  IFNULL(ctap.clienteID,0) > 0
        );
END IF;

END TerminaStore$$