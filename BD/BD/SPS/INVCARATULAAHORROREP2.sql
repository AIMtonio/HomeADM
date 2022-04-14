DELIMITER ;
DROP PROCEDURE IF EXISTS INVCARATULAAHORROREP2;
DELIMITER $$
CREATE PROCEDURE `INVCARATULAAHORROREP2`(
    -- Esta consulta corresponde al prpt de Inversiones Anexo A
	Par_Inversion				bigint(12),		
	-- Parámetros de auditoría
    Par_EmpresaID       		int,
    Aud_Usuario         		int,
    Aud_FechaActual     		DateTime,
    Aud_DireccionIP     		varchar(15),
    Aud_ProgramaID      		varchar(50),
    Aud_Sucursal        		int(11),
    Aud_NumTransaccion  		bigint	
		)
TerminaStore: BEGIN


DECLARE Var_FechaSis		DATE;
DECLARE Var_NombreGerente	VARCHAR(100);
DECLARE Var_NombreSucursal	VARCHAR(100);


DECLARE Cadena_Vacia 		CHAR(1);
DECLARE Fecha_Vacia			DATE;
DECLARE Constante_Si		CHAR(1);

DECLARE ANEXOA	INT(1);		
DECLARE FIRMASAUTORIZACION			INT(1);		
DECLARE DatosGenerales		INT(1);		
DECLARE BeneficiariosCta	INT(1);		
DECLARE Var_Vigente			CHAR(1);	

SET Cadena_Vacia			:= '';
SET Fecha_Vacia				:= '1900-01-01';
SET Constante_Si			:= 'S';

SET ANEXOA		:= 1;
SET Var_Vigente				:= 'V';


	SET Var_FechaSis	:= (SELECT FechaSistema FROM PARAMETROSSIS LIMIT 1);
			SELECT 
				CI.Descripcion as NombreProducto, 
				INV.ValorGat as GAT, 
				INV.ValorGatReal as GATReal,
				INV.Tasa as TasaInteres,
				CLI.NombreCompleto as NombreCliente,
				TC.NumRegistroRECA as RECA,
                INV.CuentaAhoID as CuentaCliente
				FROM INVERSIONES INV
				INNER JOIN CATINVERSION CI ON INV.TipoInversionID = CI.TipoInversionID
				INNER JOIN CLIENTES CLI ON CLI.ClienteID = INV.ClienteID
				INNER JOIN CUENTASAHO CAHO ON CAHO.CuentaAhoID = INV.CuentaAhoID
				INNER JOIN TIPOSCUENTAS TC ON TC.TipoCuentaID = CAHO.TipoCuentaID
				WHERE INV.InversionID=Par_Inversion;
END TerminaStore$$
