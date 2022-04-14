-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- REGULATORIOA1713REP
DELIMITER ;
DROP PROCEDURE IF EXISTS `REGULATORIOA1713REP`;DELIMITER $$

CREATE PROCEDURE `REGULATORIOA1713REP`(
-- SP QUE GENERA EL REPORTE REGULATORIO A1713 EN Excel y CSV

    Par_Fecha			VARCHAR(13),       -- Fecha del Reporte
	Par_NumLis		    TINYINT UNSIGNED,  -- Tipo :  2.- Excel , 3.- Csv

	Par_EmpresaID	    INT(11),		   -- Auditoria
	Aud_Usuario			INT(11),			-- Auditoria
	Aud_FechaActual		DATETIME,			-- Auditoria
	Aud_DireccionIP		VARCHAR(15),		-- Auditoria
	Aud_ProgramaID		VARCHAR(50),		-- Auditoria
	Aud_Sucursal		INT,				-- Auditoria
	Aud_NumTransaccion	BIGINT				-- Auditoria
	)
TerminaStore: BEGIN


DECLARE Var_ClaveEntidad VARCHAR(10);  -- Clave de la entidad


DECLARE Rep_Excel     	INT;		-- Reporte en excel
DECLARE Rep_CSV      	INT; 		-- reporte en csv
DECLARE Var_Fecha		INT;         -- Variable almacenar el valor de fecha de DATE a INTEGER
DECLARE Cadena_Vacia	CHAR; 		-- cadena vacia
DECLARE Num_Reporte		VARCHAR(5);  -- Numero del Reporte
DECLARE Nom_Mexico		VARCHAR(10); -- Nombre de Mexico
DECLARE Tipo_Sofipo		INT; 		 -- Tipo Sofipo


SET Rep_Excel		:= 2;
SET Rep_CSV         := 3;
SET Cadena_Vacia	:= '';
SET Num_Reporte		:= '1713';
SET Nom_Mexico      := 'MEXICO';
SET Tipo_Sofipo		:= 3;

SELECT IFNULL(ClaveEntidad, Cadena_Vacia) INTO Var_ClaveEntidad FROM PARAMETROSSIS WHERE EmpresaID = Par_EmpresaID;


IF(Par_NumLis = Rep_Excel) THEN

    DROP TABLE IF EXISTS TMP_GRADOESTUDIOS;
	CREATE TEMPORARY TABLE TMP_GRADOESTUDIOS(
		GradoEstudiosID 	 VARCHAR(50),
        Descripcion			 VARCHAR(250)
    );

    INSERT INTO TMP_GRADOESTUDIOS SELECT CodigoOpcion,Descripcion FROM OPCIONESMENUREG
    WHERE MenuID = 16;


    DROP TABLE IF EXISTS TMP_MANIFESTACION;
	CREATE TEMPORARY TABLE TMP_MANIFESTACION(
		ManifestacionID		VARCHAR(50),
        Descripcion			VARCHAR(250)
    );

    INSERT INTO TMP_MANIFESTACION SELECT CodigoOpcion,Descripcion FROM OPCIONESMENUREG
    WHERE MenuID = 7;


    DROP TABLE IF EXISTS TMP_PERMANENTE;
	CREATE TEMPORARY TABLE TMP_PERMANENTE(
		PermanenteID		VARCHAR(50),
        Descripcion			VARCHAR(250)
    );

    INSERT INTO TMP_PERMANENTE SELECT CodigoOpcion,Descripcion FROM OPCIONESMENUREG
    WHERE MenuID = 9;

    DROP TABLE IF EXISTS TMP_TIPOMOVIMIENTO;
	CREATE TEMPORARY TABLE TMP_TIPOMOVIMIENTO(
		TipoMovimientoID		VARCHAR(50),
        Descripcion			VARCHAR(250)
    );

    INSERT INTO TMP_TIPOMOVIMIENTO SELECT CodigoOpcion,Descripcion FROM OPCIONESMENUREG
    WHERE MenuID = 17;

	 SELECT Reg.Fecha, 					 	 Reg.RegistroID, 			 	Mov.Descripcion AS TipoMovimientoID ,
			Reg.NombreFuncionario, 		 	 Reg.RFC, 					 	Reg.CURP,
            Est.Descripcion AS Profesion, 	 Reg.Telefono, 				 	Reg.Email,
            Nom_Mexico AS PaisID,	    	 Erp.Nombre AS EstadoID, 	 	Mun.Nombre AS MunicipioID,
            Reg.LocalidadID, 			 	 Col.Asentamiento, 			 	Reg.CodigoPostal,
		    Reg.Calle, 					 	 Reg.NumeroExt, 			 	Reg.NumeroInt,
            Reg.FechaMovimiento, 	     	 Reg.FechaInicioGes, 	     	Reg.FechaFinGestion,
            Org.Descripcion AS OrganoID, 	 Car.Descripcion AS CargoID, 	Per.Descripcion AS PermanenteID,
            Baj.Descripcion  AS CausaBajaID, Man.Descripcion AS ManifestCumpID,
            Var_ClaveEntidad AS ClaveEntidad,Num_Reporte AS Reporte
	 FROM   REGISTROREGA1713  Reg,		COLONIASREPUB Col,			TMP_GRADOESTUDIOS Est,		TMP_MANIFESTACION Man,
			TMP_PERMANENTE Per,			TMP_TIPOMOVIMIENTO Mov,	    CATCAUSABAJA Baj,
            CATCARGOSOCIEDAD Car, 		CATORGANO Org, 				ESTADOSREPUB Erp,
            MUNICIPIOSREPUB  Mun
	 WHERE Reg.Profesion 		= Est.GradoEstudiosID
	 AND   Reg.ManifestCumpID 	= Man.ManifestacionID
	 AND   Reg.PermanenteID 	= Per.PermanenteID
	 AND   Reg.TipoMovimientoID = Mov.TipoMovimientoID
	 AND   Reg.CausaBajaID 		= Baj.CausaBajaID
	 AND   Reg.CargoID 			= Car.CargoID
     AND   Car.TipoInstitID		= Tipo_Sofipo
	 AND   Reg.OrganoID 		= Org.OrganoID
     AND   Org.TipoInstitID		= Tipo_Sofipo
     AND   Reg.EstadoID 		= Erp.EstadoID
	 AND   Reg.EstadoID 		= Col.EstadoID
	 AND   Reg.MunicipioID  	= Col.MunicipioID
	 AND   Reg.ColoniaID		= Col.ColoniaID
	 AND   Reg.EstadoID 		= Mun.EstadoID
	 AND   Reg.MunicipioID 		= Mun.MunicipioID
	 AND   Reg.Fecha 			= Par_Fecha;
END IF;

IF(Par_NumLis = Rep_CSV) THEN
	SELECT CONCAT(
			Num_Reporte,';',			Reg.TipoMovimientoID,';',	 Reg.NombreFuncionario,';',
			Reg.RFC,';',        		Reg.CURP,';',				 Reg.Profesion,';',
			Reg.Calle,';', 				Reg.NumeroExt,';', 			 Reg.NumeroInt,';',
			Col.Asentamiento,';', 		Reg.CodigoPostal,';', 		 Reg.LocalidadID,';',
			Reg.MunicipioID,';',   		Reg.EstadoID,';', 			 Reg.PaisID,';',
			Reg.Telefono,';',	        Reg.Email,';',	        	 Reg.FechaMovimiento,';',
			Reg.FechaInicioGes,';',     Reg.FechaFinGestion,';',	 Reg.OrganoID,';',
			Reg.CargoID,';',        	Reg.PermanenteID,';', 		 Reg.CausaBajaID,';',
			Reg.ManifestCumpID
	) AS Renglon
	 FROM REGISTROREGA1713 Reg,COLONIASREPUB Col
	 WHERE Reg.EstadoID 	= Col.EstadoID
	 AND   Reg.MunicipioID  = Col.MunicipioID
	 AND   Reg.ColoniaID	= Col.ColoniaID
     AND   Reg.Fecha 		= Par_Fecha;
END IF;


END TerminaStore$$