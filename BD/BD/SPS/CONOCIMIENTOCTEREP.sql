-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- CONOCIMIENTOCTEREP
DELIMITER ;
DROP PROCEDURE IF EXISTS `CONOCIMIENTOCTEREP`;DELIMITER $$

CREATE PROCEDURE `CONOCIMIENTOCTEREP`(
	Par_ClienteID      BIGINT(20),

    Par_EmpresaID       INT,
    Aud_Usuario         INT,
    Aud_FechaActual     DATETIME,
    Aud_DireccionIP     VARCHAR(15),
    Aud_ProgramaID      VARCHAR(50),
    Aud_Sucursal        INT(11),
    Aud_NumTransaccion  BIGINT(20)

	)
TerminaStore:BEGIN
-- Declaracion de Variables
DECLARE Var_DireccionOficialCte VARCHAR(500);
DECLARE Var_NivelRiesgo         CHAR(1);

-- Declaracion de Constantes
DECLARE Si		 			CHAR(1);
DECLARE Con_No				CHAR(1);
DECLARE Cadena_Vacia		CHAR;

DECLARE Des_Soltero			VARCHAR(50);
DECLARE Des_CasBieSep		VARCHAR(50);
DECLARE Des_CasBieMan		VARCHAR(50);
DECLARE Des_CasCapitu		VARCHAR(50);
DECLARE Des_Viudo			VARCHAR(50);
DECLARE Des_Divorciad		VARCHAR(50);
DECLARE Des_Seperados		VARCHAR(50);
DECLARE Des_UnionLibre		VARCHAR(50);


DECLARE Est_Soltero     	CHAR(2);
DECLARE Est_CasBieSep   	CHAR(2);
DECLARE Est_CasBieMan   	CHAR(2);
DECLARE Est_CasCapitu   	CHAR(2);
DECLARE Est_Viudo      	 	CHAR(2);
DECLARE Est_Divorciad   	CHAR(2);
DECLARE Est_Seperados   	CHAR(2);
DECLARE Est_UnionLibre  	CHAR(2);

DECLARE	Persona_Moral  		CHAR(1);
DECLARE	Persona_Fisica 		CHAR(1);
DECLARE	Persona_FisicaAE 	CHAR(1);

DECLARE Cober_Local  		CHAR(1);
DECLARE Cober_Estatal 		CHAR(1);
DECLARE Cober_Regional 		CHAR(1);
DECLARE Cober_Nacional 		CHAR(1);
DECLARE Cober_Internac 		CHAR(1);
DECLARE menosMil			VARCHAR(50);
DECLARE milCincomil			VARCHAR(50);
DECLARE cincomilDiezmil		VARCHAR(50);
DECLARE mayorDiezmil		VARCHAR(50);
DECLARE menosMilE			VARCHAR(50);
DECLARE milCincomilE		VARCHAR(50);
DECLARE cincomilDiezmilE	VARCHAR(50);
DECLARE mayorDiezmilE		VARCHAR(50);


DECLARE menosVeinteMil			VARCHAR(50);
DECLARE veintemilCincuentamil	VARCHAR(50);
DECLARE cincuentamilCienmil		VARCHAR(50);
DECLARE mayorCienmil			VARCHAR(50);
-- Asignacion de Constantes
SET Si 				:='S';		-- Si
SET Con_No			:='N';		-- Constante no
SET Cadena_Vacia	:='';		 -- Cadena Vacia

SET Des_Soltero     := 'SOLTERO(A)';
SET Des_CasBieSep   := 'CASADO(A) BIENES SEPARADOS';
SET Des_CasBieMan   := 'CASADO(A) BIENES MANCOMUNADOS';
SET Des_CasCapitu   := 'CASADO(A) BIENES MANCOMUNADOS CON CAPITULACION';
SET Des_Viudo       := 'VIUDO(A)';
SET Des_Divorciad   := 'DOVORCIADO(A)';
SET Des_Seperados   := 'SEPERADO(A)';
SET Des_UnionLibre  := 'UNION LIBRE';

SET Est_Soltero     := 'S';        -- Estado Civil Soltero
SET Est_CasBieSep   := 'CS';       -- Casado Bienes Separados
SET Est_CasBieMan   := 'CM';       -- Casado Bienes Mancomunados
SET Est_CasCapitu   := 'CC';       -- Casado Bienes Mancomunados Con Capitulacion
SET Est_Viudo       := 'V';        -- Viudo
SET Est_Divorciad   := 'D';        -- Divorciado
SET Est_Seperados   :='SE';        -- Separado
SET Est_UnionLibre  := 'U';        -- Union Libre

SET Persona_Moral = 'M';			-- Persona Moral
SET Persona_Fisica ='A';			-- Persona Fisica conActividad Empresarial
SET Persona_FisicaAE='F';			-- Persona Fisica sin Actividad Empresarial

SET Cober_Local  	:='L';			-- Cobertura Local
SET Cober_Estatal 	:='E';			-- cobertura Estatal
SET Cober_Regional 	:='R';			-- Cobertura Regional
SET Cober_Nacional 	:='N';			-- Conertura Nacional
SET Cober_Internac 	:='I';			-- Cobertura Internacional

SET menosMil 		:='Dimp';
SET milCincomil		:='DImp2';
SET cincomilDiezmil	:='DImp3';
SET mayorDiezmil	:='DImp4';

SET menosMilE		:='DExp';
SET milCincomilE	:='DExp2';
SET cincomilDiezmilE:='DExp3';
SET mayorDiezmilE	:='DExp4';

SET menosVeinteMil			:='Ing1';
SET veintemilCincuentamil	:='Ing2';
SET cincuentamilCienmil		:='Ing3';
SET mayorCienmil			:='Ing4';


SELECT DireccionCompleta INTO Var_DireccionOficialCte
	FROM DIRECCLIENTE
		WHERE ClienteID=Par_ClienteID
		AND Oficial=Si
		LIMIT 1;

SET Var_DireccionOficialCte= CONCAT(Var_DireccionOficialCte,',',' ','MEXICO');

SET Var_DireccionOficialCte := IFNULL(Var_DireccionOficialCte,Cadena_Vacia);

SET Var_NivelRiesgo = (SELECT NivelRiesgo FROM CLIENTES WHERE ClienteID = Par_ClienteID);


SELECT ccte.NomGrupo,FORMAT(ccte.Participacion,2) AS Participacion ,ccte.RFC,ccte.Nacionalidad,ccte.RazonSocial,
		(CASE WHEN PEPs = Si THEN 'SI'
			WHEN PEPs = Con_No THEN 'NO'END) AS PEPs,
		ccte.FuncionID,fp.Descripcion AS DescripFuncionPublica,
		(CASE WHEN ParentescoPEP=Si THEN 'SI'
			WHEN ParentescoPEP=Con_No THEN 'NO' END) AS ParentescoPEP,
		CONCAT(ccte.NombFamiliar,' ',ccte.APaternoFam,' ',ccte.AMaternoFam) AS NombFamiliar,
		ImporteVta,
		Activos,
		Pasivos,
		Capital,
		(CASE WHEN Importa=Si THEN 'SI'
			WHEN Importa=Con_No THEN 'NO'END) AS Importa,
		Giro,NoEmpleados,Serv_Produc,
		(CASE WHEN Cober_Geograf=Cober_Local THEN 'LOCAL'
			WHEN  Cober_Geograf=Cober_Estatal THEN 'ESTATAL'
			WHEN  Cober_Geograf=Cober_Regional THEN 'REGIONAL'
			WHEN  Cober_Geograf=Cober_Nacional THEN 'NACIONAL'
			WHEN  Cober_Geograf=Cober_Internac THEN 'INTERNACIONAL' END) AS Cober_Geograf,
			Estados_Presen,
			(CASE WHEN Exporta=Si THEN 'SI'
			WHEN Exporta=Con_No THEN 'NO'END) AS Exporta, NombRefCom,NombRefCom2,TelRefCom,TelRefCom2,
		BancoRef,BancoRef2,NoCuentaRef,NoCuentaRef2,NombreRef,NombreRef2,DomicilioRef,
		DomicilioRef2,TelefonoRef,TelefonoRef2,PFuenteIng,
		CASE WHEN IngAproxMes=menosVeinteMil THEN 'Menos de 20,000.00'
			WHEN IngAproxMes=veintemilCincuentamil THEN '20,001.00 a 50,000.00'
			WHEN IngAproxMes=cincuentamilCienmil THEN '50,001.00 a 100,000.00'
			WHEN IngAproxMes=mayorCienmil THEN 'Mayor a 100,000.00'END AS IngAproxMes,
		cte.ClienteID,cte.NombreCompleto AS NombreCliente,cte.RFCOficial, cte.CURP,
		(CASE WHEN EstadoCivil=Est_Soltero  THEN Des_Soltero
				WHEN  EstadoCivil=Est_CasBieSep THEN Des_CasBieSep
				WHEN EstadoCivil=Est_CasBieMan THEN Des_CasBieMan
				WHEN EstadoCivil=Est_CasCapitu THEN Des_CasCapitu
				WHEN EstadoCivil=Est_Viudo		THEN Des_Viudo
				WHEN EstadoCivil=Est_Divorciad THEN Est_Divorciad
				WHEN EstadoCivil=Est_Seperados THEN Des_Seperados
				WHEN EstadoCivil=Est_UnionLibre THEN Est_UnionLibre
			END) AS EstadoCivil,ocu.Descripcion,pais.Nombre AS NombrePais,est.Nombre AS NombreEstado,
			(CASE WHEN TipoPersona = Persona_Moral THEN 'PERSONA MORAL'
				WHEN TipoPersona =Persona_Fisica  THEN 'PERSONA FISICA CON ACTIVIDAD EMPRESARIAL'
				WHEN TipoPersona=Persona_FisicaAE THEN 'PERSONA FISICA SIN ACTIVIDAD EMPRESARIAL'
			END) AS TipoPersona,
			(CASE WHEN DolaresImport=menosMil THEN 'Menos de 1,000.00'
				WHEN DolaresImport=milCincomil THEN '1,001.00 a 5,000.00'
				WHEN DolaresImport=cincomilDiezmil THEN '5,001.00 a 10,000.00'
				WHEN DolaresImport=mayorDiezmil THEN 'Mayores de 10,001.00'END) AS DolaresImporta,
			CASE WHEN DolaresExport=menosMilE THEN 'Menos de 1,000.00'
				WHEN DolaresExport=milCincomilE THEN '1,001.00 a 5,000.00'
				WHEN DolaresExport=cincomilDiezmilE THEN '5,001.00 a 10,000.00'
				WHEN DolaresExport=mayorDiezmilE THEN 'Mayores de 10,001.00'END AS DolaresExporta,
			cte.Telefono , suc.NombreSucurs,Var_DireccionOficialCte,

ccte.PreguntaCte1, ccte.RespuestaCte1,
ccte.PreguntaCte2, ccte.RespuestaCte2,
ccte.PreguntaCte3, ccte.RespuestaCte3,
ccte.PreguntaCte4, ccte.RespuestaCte4, Var_NivelRiesgo,
CapitalContable

	FROM CONOCIMIENTOCTE ccte
		LEFT JOIN FUNCIONESPUB fp ON fp.FuncionID=ccte.FuncionID,
			CLIENTES cte
			 LEFT JOIN OCUPACIONES ocu ON ocu.OcupacionID=cte.OcupacionID
			LEFT JOIN PAISES	pais ON pais.PaisID=cte.LugarNacimiento
			LEFT JOIN ESTADOSREPUB	est	ON est.EstadoID =cte.EstadoID
			LEFT JOIN SUCURSALES suc ON SucursalID=SucursalOrigen
		WHERE ccte.ClienteID=Par_ClienteID
			AND ccte.ClienteID=cte.ClienteID;

/*
numero de cliente sin comas

*/
END TerminaStore$$