-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- USUARIOSERVICIOREP
DELIMITER ;
DROP PROCEDURE IF EXISTS `USUARIOSERVICIOREP`;DELIMITER $$

CREATE PROCEDURE `USUARIOSERVICIOREP`(

    Par_UsuarioID				INT(11),
	Par_SucursalID				INT,
    Par_Sexo            		VARCHAR(10),
    Par_NumCon					TINYINT UNSIGNED,

    Par_EmpresaID      		 	INT(11),
    Aud_Usuario         		INT(11),
    Aud_FechaActual     		DATETIME,
    Aud_DireccionIP     		VARCHAR(15),
    Aud_ProgramaID      		VARCHAR(50),

    Aud_Sucursal        		INT(11),
    Aud_NumTransaccion  		BIGINT(20)
		)
TerminaStore: BEGIN

DECLARE Var_Sentencia 			VARCHAR(15000);
DECLARE Var_SentenciaTabla 		VARCHAR(500);
DECLARE Var_TipoPersona			VARCHAR(20);
DECLARE Var_Fisica				CHAR(1);
DECLARE Var_FisicaAct			CHAR(1);
DECLARE Var_Moral				CHAR(1);
DECLARE Var_FisicaDes			VARCHAR(20);
DECLARE Var_FisicaActDes		VARCHAR(40);
DECLARE Var_MoralDes			VARCHAR(20);
DECLARE Var_Femenino			CHAR(5);
DECLARE Var_Masculino			CHAR(5);
DECLARE Var_FemeninoDes			VARCHAR(20);
DECLARE Var_MasculinoDes		VARCHAR(20);
DECLARE Var_Nacional			CHAR(1);
DECLARE Var_Extranjera			CHAR(1);
DECLARE Var_NacionalDes			VARCHAR(20);
DECLARE Var_ExtranjeraDes		VARCHAR(20);


DECLARE	Cadena_Vacia			CHAR(1);
DECLARE	Fecha_Vacia				DATE;
DECLARE	Entero_Cero				INT;
DECLARE Con_ReportePDF			TINYINT UNSIGNED;
DECLARE Con_ReporteExcel		TINYINT UNSIGNED;



SET	Cadena_Vacia				:= '';
SET	Fecha_Vacia					:= '1900-01-01';
SET	Entero_Cero					:= 0;
SET Con_ReportePDF				:= 1;
SET Con_ReporteExcel			:= 2;


SET Var_Sentencia 				:= '';
SET Var_SentenciaTabla 			:= '';
SET	Var_Fisica					:= 'F';
SET	Var_FisicaAct				:= 'A';
SET	Var_Moral					:= 'M';
SET	Var_FisicaDes				:= 'FISICA';
SET	Var_FisicaActDes			:= 'FISICA CON ACTIVIDAD EMPRESARIAL';
SET	Var_MoralDes				:= 'MORAL';
SET Var_Femenino				:= 'F';
SET Var_Masculino				:= 'M';
SET Var_FemeninoDes				:= 'FEMENINO';
SET Var_MasculinoDes			:= 'MASCULINO';
SET Var_Nacional				:= 'N';
SET Var_Extranjera				:= 'E';
SET Var_NacionalDes				:= 'MEXICANA' ;
SET Var_ExtranjeraDes			:= 'EXTRANJERA';


 DROP TABLE IF EXISTS 	TMPDATOSREPORTE;
 CREATE TEMPORARY TABLE TMPDATOSREPORTE (

    UsuarioServicioID		INT,
	TipoPersona   			VARCHAR(40),
    NombreCompleto	     	VARCHAR(150),
    FechaNac        		DATE,
	Nacion          		VARCHAR(20),
    PaisRes	        		VARCHAR(20),

    EstadoNac        		VARCHAR(20),
	DirCompleta				VARCHAR(150),
	Sexo            		VARCHAR(15),
    CURP            		CHAR(18),
	RazonSocial     		VARCHAR(150),

	RFC             		CHAR(13),
    TipoSociedad     		VARCHAR(120),
	Ocupacion     			VARCHAR(120),
    SucursalOrigen			INT,
	FechaConstitucion		DATE
  );


  SET Var_SentenciaTabla := '
	INSERT INTO TMPDATOSREPORTE(

		UsuarioServicioID,
		TipoPersona,
        NombreCompleto,
		FechaNac,
		Nacion,
		PaisRes,

		EstadoNac,
		DirCompleta,
		Sexo,
		CURP,
		RazonSocial,

		RFC,
		Ocupacion,
        SucursalOrigen,
   		FechaConstitucion
	)';
IF(Par_NumCon =Con_ReportePDF || Par_NumCon =Con_ReporteExcel) THEN

SET Var_Sentencia := CONCAT(Var_SentenciaTabla,  '
	SELECT 	Usa.UsuarioServicioID,		Usa.TipoPersona,		Usa.NombreCompleto,		Usa.FechaNacimiento, 		Usa.Nacionalidad,
			trim(left(Pai.Nombre,20)) AS PaisRes, 				trim(left(Est.Nombre,20)) AS EstadoNac, 			Usa.DirCompleta,	 Usa.Sexo, 	 		Usa.CURP,
			Usa.RazonSocial,			Usa.RFC, 			    LEFT(concat(ifnull(Soc.Descripcion,"',Cadena_Vacia,'"),"',Cadena_Vacia,'",ifnull(Ocu.Descripcion,"',Cadena_Vacia,'")),120) AS Ocupacion,
			Usa.SucursalOrigen,			Usa.FechaConstitucion
		FROM USUARIOSERVICIO Usa
        LEFT JOIN OCUPACIONES  	Ocu 	ON	Ocu.OcupacionID     =Usa.OcupacionID 	  AND Ocu.OcupacionID     =Usa.OcupacionID
        LEFT JOIN PAISES  		Pai 	ON	Pai.PaisID 		    =Usa.PaisResidencia   AND Pai.PaisID  		  =Usa.PaisResidencia
        LEFT JOIN ESTADOSREPUB  Est 	ON	Est.EstadoID	 	=Usa.EstadoNacimiento AND Est.EstadoID 		  =Usa.EstadoNacimiento
        LEFT JOIN TIPOSOCIEDAD  Soc 	ON	Soc.TipoSociedadID  =Usa.TipoSociedadID   AND Soc.TipoSociedadID  =Usa.TipoSociedadID
        WHERE  Usa.UsuarioServicioID >"',Entero_Cero,'" '
);

    SET Par_UsuarioID := ifnull(Par_UsuarioID,Entero_Cero);
	IF(Par_UsuarioID != Entero_Cero) THEN
		SET Var_Sentencia := CONCAT(Var_Sentencia,' AND Usa.UsuarioServicioID=',Par_UsuarioID);
     END IF;


  SET Par_SucursalID := ifnull(Par_SucursalID,Entero_Cero);
	IF(Par_SucursalID != Entero_Cero) THEN
		SET Var_Sentencia := CONCAT(Var_Sentencia,' AND Usa.SucursalOrigen=',Par_SucursalID);
   END IF;

    SET Par_Sexo := ifnull(Par_Sexo,Cadena_Vacia);
    IF(Par_Sexo != Cadena_Vacia)THEN
	IF(Par_Sexo=Var_Femenino) THEN
		SET Var_Sentencia := CONCAT(Var_sentencia,' AND Usa.Sexo=',"'F'");
	END IF;

	IF(Par_Sexo=Var_Masculino) THEN
		SET Var_Sentencia := CONCAT(Var_Sentencia,' AND Usa.Sexo=',"'M'");
	END IF;

END IF;

 SET @Sentencia	= (Var_Sentencia);
	PREPARE USUARIOSERVICIOREP FROM @Sentencia;
	EXECUTE USUARIOSERVICIOREP;
	DEALLOCATE PREPARE USUARIOSERVICIOREP;

    UPDATE TMPDATOSREPORTE SET TipoPersona 	= Var_FisicaDes 	WHERE TipoPersona = Var_Fisica;
	UPDATE TMPDATOSREPORTE SET TipoPersona	= Var_FisicaActDes  WHERE TipoPersona = Var_FisicaAct;
	UPDATE TMPDATOSREPORTE SET TipoPersona 	= Var_MoralDes 		WHERE TipoPersona = Var_Moral;
    UPDATE TMPDATOSREPORTE SET Sexo 		= Var_FemeninoDes 	WHERE Sexo 		  = Var_Femenino;
    UPDATE TMPDATOSREPORTE SET Sexo 		= Var_MasculinoDes 	WHERE Sexo 		  = Var_Masculino;
    UPDATE TMPDATOSREPORTE SET Nacion 		= Var_NacionalDes	WHERE Nacion 	  = Var_Nacional;
	UPDATE TMPDATOSREPORTE SET Nacion 		= Var_ExtranjeraDes WHERE Nacion 	  = Var_Extranjera;


    SELECT 	UsuarioServicioID, 	TipoPersona,  	NombreCompleto, 		FechaNac,	 Nacion,
			PaisRes,			EstadoNac,	 	DirCompleta,			Sexo,        CURP,
			RazonSocial, 		RFC, 			Ocupacion,
			SucursalOrigen,		FechaConstitucion
            FROM TMPDATOSREPORTE;

	DROP TABLE IF EXISTS 	TMPDATOSREPORTE;
END IF;

END TerminaStore$$