-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- CARGOSOBJETADOSLIS
DELIMITER ;
DROP PROCEDURE IF EXISTS `CARGOSOBJETADOSLIS`;
DELIMITER $$

CREATE PROCEDURE `CARGOSOBJETADOSLIS`(
    Par_clienteID				INT(11),
    Par_FechaIni				DATETIME,
    Par_FechaFin				DATETIME,
	Par_TipoLista				TINYINT UNSIGNED,
  
  
	Par_EmpresaID				INT(11),
	Aud_Usuario					INT(11),
	Aud_FechaActual				DATETIME,
	Aud_DireccionIP				VARCHAR(15),  
	Aud_ProgramaID				VARCHAR(50),
	Aud_Sucursal				INT(11),
	Aud_NumTransaccion			BIGINT(20)
)
TerminaStore: BEGIN


DECLARE	Lista_Principal	INT(11);
DECLARE	Cadena_Vacia	VARCHAR(1);
DECLARE	Fecha_Vacia		DATE;
DECLARE	Entero_Cero		INT(11);
DECLARE	SalidaSI        CHAR(1);
DECLARE Entero_Dos		INT(1);
DECLARE	SalidaNO        CHAR(1);
DECLARE Var_AnioIni		INT(4);
DECLARE Var_MesIni	    INT(2);
DECLARE Var_AnioFin		INT(4);
DECLARE Var_MesFin	    INT(2);
DECLARE Var_Periodo	    INT(8);




SET Cadena_Vacia		:= '';		
SET Fecha_Vacia			:= '1900-01-01';
SET Entero_Cero			:= 0;		
SET	SalidaSI        	:= 'S';		
SET	SalidaNO        	:= 'N';
SET Entero_Dos			:= 2;	
SET	Lista_Principal     := 1;
	
	

IF(IFNULL(Par_TipoLista, Entero_Cero)) = Lista_Principal THEN

    SELECT  SUBSTR(Par_FechaIni, 1, 4) INTO Var_AnioIni;
	SELECT  SUBSTR(Par_FechaFin, 1, 4) INTO Var_AnioFin;
    SELECT  SUBSTR(Par_FechaIni, 6, 2) INTO Var_MesIni;
    SELECT  SUBSTR(Par_FechaFin, 6, 2) INTO Var_MesFin;
  
    IF(Var_MesIni != Var_MesFin) THEN
    
        SET Var_Periodo := CONCAT(Var_AnioIni,LPAD(Var_MesIni,Entero_Dos,Entero_Cero),Var_MesFin);
	ELSE
 
		SET Var_Periodo := CONCAT(Var_AnioIni,LPAD(Var_MesIni,Entero_Dos,Entero_Cero));
    END IF;
  
	SELECT Fecha,Folio, InstrumentoID AS Instrumento, Descripcion, Cargo, Abono
	FROM CARGOSOBJETADOS CA INNER JOIN CREDITOS CE
    ON CE.CreditoID =CA.InstrumentoID WHERE CE.ClienteID=Par_clienteID AND CA.Periodo = Var_Periodo
	UNION
	SELECT Fecha,Folio, InstrumentoID AS Instrumento, Descripcion, Cargo, Abono
	FROM CARGOSOBJETADOS CA INNER JOIN CUENTASAHO CAH ON  CAH.CuentaAhoID = CA.InstrumentoID
	WHERE CAH.ClienteID=Par_clienteID AND CA.Periodo = Var_Periodo;
END IF;

END TerminaStore$$