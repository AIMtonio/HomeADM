-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- HISPARAMETROSESCALAREP
DELIMITER ;
DROP PROCEDURE IF EXISTS `HISPARAMETROSESCALAREP`;DELIMITER $$

CREATE PROCEDURE `HISPARAMETROSESCALAREP`(

	Par_TipoPersona			CHAR(1),
	Par_TipoInstrumento		INT(11),
	Par_NacMoneda			CHAR(1),
    Par_TipoReporte			TINYINT UNSIGNED,

    Aud_EmpresaID			INT,
	Aud_Usuario				INT,
	Aud_FechaActual			DATETIME,

	Aud_DireccionIP			VARCHAR(15),
	Aud_ProgramaID			VARCHAR(50),
    Aud_SucursalID			INT,
    Aud_NumTransaccion		BIGINT
			)
TerminaStore: BEGIN


DECLARE	Cadena_Vacia		CHAR(1);
DECLARE	Fecha_Vacia			DATE;
DECLARE	Entero_Cero			INT;
DECLARE Decimal_Cero		DECIMAL(12,2);
DECLARE MonedaNac			CHAR(1);
DECLARE MonedaExt			CHAR(1);
DECLARE SalidaSi			CHAR(1);
DECLARE SalidaNo			CHAR(1);
DECLARE EstatusVigente		CHAR(1);
DECLARE ReporteHistorico	INT(11);
DECLARE PersFisica			CHAR(1);
DECLARE PersMoral			CHAR(1);
DECLARE DescPersFisica		CHAR(15);
DECLARE DescPersMoral		CHAR(15);
DECLARE DescMonedaNac		CHAR(20);
DECLARE DescMonedaExt		CHAR(20);


SET	Cadena_Vacia		:= '';
SET	Fecha_Vacia			:= '1900-01-01';
SET	Entero_Cero			:= 0;
SET Decimal_Cero		:= 0.0;
SET	MonedaNac			:= 'N';
SET	MonedaExt			:= 'E';
SET	SalidaSi			:= 'S';
SET	SalidaNo			:= 'N';
SET EstatusVigente		:= 'V';
SET ReporteHistorico	:= 1;
SET	PersFisica			:= 'F';
SET PersMoral			:= 'M';
SET	DescPersFisica		:= 'PERSONA FISICA';
SET DescPersMoral		:= 'PERSONA MORAL';
SET	DescMonedaNac		:= 'NACIONAL';
SET DescMonedaExt		:= 'EXTRANJERA';


IF(IFNULL(Par_TipoReporte,Entero_Cero)=ReporteHistorico)THEN
	DROP TABLE IF EXISTS TMPREPORTEESCALA;


    CREATE TEMPORARY TABLE TMPREPORTEESCALA(
	  `TipoPersona` 		VARCHAR(15),
	  `TipoInstrumento` 	VARCHAR(55),
	  `NacMoneda` 			VARCHAR(30),
	  `LimiteInferior` 		DECIMAL(14,2),
	  `MonedaComp` 			VARCHAR(85),
	  `RolTitular` 			INT(11),
	  `RolSuplente` 		INT(11),
	  `DescRolTitular` 		VARCHAR(100),
	  `DescRolSuplente` 	VARCHAR(100),
	  `FechaModificacion`	DATE,
	  `FechaActual`			DATETIME,
	  `ClaveUsuario`		VARCHAR(50),
      INDEX(`TipoPersona`, `TipoInstrumento`, `NacMoneda`)
    );


    INSERT INTO TMPREPORTEESCALA (
	  TipoPersona,
	  TipoInstrumento,
	  NacMoneda,
	  LimiteInferior, 	MonedaComp,
	  RolTitular, 		RolSuplente, FechaModificacion, FechaActual, ClaveUsuario)
      SELECT
			CASE TipoPersona
				WHEN PersFisica THEN DescPersFisica
				WHEN PersMoral	THEN DescPersMoral
			END AS TipoPersona,
            CONCAT(CONVERT(TipoInstrumento,CHAR),' - ', I.Descripcion) AS TipoInstrumento,
            CASE NacMoneda
				WHEN MonedaNac THEN DescMonedaNac
				WHEN MonedaExt THEN DescMonedaExt
            END AS NacMoneda,
            LimiteInferior,		CONCAT(CONVERT(MonedaComp,CHAR),' - ', M.Descripcion) MonedaComp,
            RolTitular,			RolSuplente, 	FechaModificacion, 		H.FechaActual, UPPER(U.Clave)
		FROM HISPARAMETROSESCALA H INNER JOIN TIPOINSTRUMMONE I ON(H.TipoInstrumento=I.TipoInstruMonID)
			INNER JOIN MONEDAS M ON(H.MonedaComp=M.MonedaId)
            INNER JOIN USUARIOS U ON(H.Usuario=U.UsuarioID)
			WHERE TipoPersona 		= Par_TipoPersona
				AND TipoInstrumento = Par_TipoInstrumento
				AND NacMoneda 		= Par_NacMoneda;


	UPDATE TMPREPORTEESCALA, ROLES SET
		DescRolTitular = NombreRol
        WHERE RolTitular= RolID;


	UPDATE TMPREPORTEESCALA, ROLES SET
		DescRolSuplente = NombreRol
        WHERE RolSuplente= RolID;


	SELECT
		TipoPersona,	TipoInstrumento,  NacMoneda,  		LimiteInferior,		MonedaComp,
		RolTitular,	  	RolSuplente,	  DescRolTitular,	DescRolSuplente,	FechaModificacion,
        ClaveUsuario
      FROM TMPREPORTEESCALA
      ORDER BY FechaActual DESC;

	DROP TABLE IF EXISTS TMPREPORTEESCALA;
END IF;

END TerminaStore$$