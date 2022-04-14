-- TABLA HISCONOCIMIENTOUSUSERV

DELIMITER ;
DROP TABLE IF EXISTS `HISCONOCIMIENTOUSUSERV`;

DELIMITER $$
CREATE TABLE `HISCONOCIMIENTOUSUSERV` (
  `NumTransaccionAct`       BIGINT(20)      NOT NULL                      COMMENT 'Numero de Transaccion que realizo la actualización de los datos',
  `UsuarioServicioID`       BIGINT(11)      NOT NULL                      COMMENT 'Identificador del usuario de servicios.',
  `NombreGrupo`             VARCHAR(100)    NOT NULL DEFAULT ''           COMMENT 'Grupo o filial - Nombre de persona.',
  `RFC`                     VARCHAR(13)     NOT NULL DEFAULT ''           COMMENT 'Grupo o filial - RFC de persona.',
  `Participacion`           DECIMAL(14, 2)  NOT NULL DEFAULT '0.00'       COMMENT 'Grupo o filial - Porcentaje de participacion.',
  `Nacionalidad`            VARCHAR(45)     NOT NULL DEFAULT ''           COMMENT 'Grupo o filial - Nacionalidad de persona.',
  `RazonSocial`             VARCHAR(150)    NOT NULL DEFAULT ''           COMMENT 'Actividad empresarial - Razon social.',
  `Giro`                    VARCHAR(150)    NOT NULL DEFAULT ''           COMMENT 'Actividad empresarial - Giro de la empresa.',
  `AniosOperacion`          INT(11)         NOT NULL DEFAULT '0'          COMMENT 'Actividad empresarial - Años de operación.',
  `AniosGiro`               INT(11)         NOT NULL DEFAULT '0'          COMMENT 'Actividad empresarial - Años de giro.',
  `PEPs`                    CHAR(1)         NOT NULL DEFAULT ''           COMMENT 'Actividad empresarial - Confirmación persona expuesta politicamente S=si, N=no.',
  `FuncionID`               INT(11)         NOT NULL DEFAULT '0'          COMMENT 'Actividad empresarial - Identificador de la función.',
  `ParentescoPEP`           CHAR(1)         NOT NULL DEFAULT ''           COMMENT 'Actividad empresarial - Confirmación de parentesco con PEP S=si, N=no.',
  `NombreFamiliar`          VARCHAR(50)     NOT NULL DEFAULT ''           COMMENT 'Actividad empresarial - Nombre del familiar.',
  `APaternoFamiliar`        VARCHAR(50)     NOT NULL DEFAULT ''           COMMENT 'Actividad empresarial - Apellido paterno del familiar.',
  `AMaternoFamiliar`        VARCHAR(50)     NOT NULL DEFAULT ''           COMMENT 'Actividad empresarial - Apellido materno del familiar.',
  `CoberturaGeografica`     CHAR(1)         NOT NULL DEFAULT ''           COMMENT 'Actividad empresarial - L=local, E=estatal, R=regional, N=nacional, I=internacional.',
  `Activos`                 DECIMAL(14, 2)  NOT NULL DEFAULT '0.00'       COMMENT 'Actividad empresarial - Importe activos.',
  `Pasivos`                 DECIMAL(14, 2)  NOT NULL DEFAULT '0.00'       COMMENT 'Actividad empresarial - Importe de pasivos.',
  `CapitalNeto`             DECIMAL(14, 2)  NOT NULL DEFAULT '0.00'       COMMENT 'Actividad empresarial - Capital neto de la empresa.',
  `Importa`                 CHAR(1)         NOT NULL DEFAULT ''           COMMENT 'Actividad empresarial - Confirmación de importacion S=si, N=no.',
  `DolaresImporta`          VARCHAR(10)     NOT NULL DEFAULT ''           COMMENT 'Actividad empresarial - DImp1=menos1000, DImp2=1001-5000, DImp3=5001-10000, DImp4=mayor10001.',
  `PaisesImporta1`          VARCHAR(50)     NOT NULL DEFAULT ''           COMMENT 'Actividad empresarial - Paises a los que se importa (DImp1=menos1000).',
  `PaisesImporta2`          VARCHAR(50)     NOT NULL DEFAULT ''           COMMENT 'Actividad empresarial - Paises a los que se importa (DImp2=1001-5000).',
  `PaisesImporta3`          VARCHAR(50)     NOT NULL DEFAULT ''           COMMENT 'Actividad empresarial - Paises a los que se importa (DImp3=5001-10000).',
  `Exporta`                 CHAR(1)         NOT NULL DEFAULT ''           COMMENT 'Actividad empresarial - Confirmación de exportación S=si, N=no.',
  `DolaresExporta`          VARCHAR(10)     NOT NULL DEFAULT ''           COMMENT 'Actividad empresarial - DExp1=menos1000, DExp2=1001-5000, DExp3=5001-10000, DExp4=mayor10001.',
  `PaisesExporta1`          VARCHAR(50)     NOT NULL DEFAULT ''           COMMENT 'Actividad empresarial - Paises a los que se exporta (DExp1=menos1000).',
  `PaisesExporta2`          VARCHAR(50)     NOT NULL DEFAULT ''           COMMENT 'Actividad empresarial - Paises a los que se exporta (DExp2=1001-5000).',
  `PaisesExporta3`          VARCHAR(50)     NOT NULL DEFAULT ''           COMMENT 'Actividad empresarial - Paises a los que se exporta (DExp3=5001-10000).',
  `PrincipalFuenteIng`      VARCHAR(100)    NOT NULL DEFAULT ''           COMMENT 'Principal fuente de ingresos.',
  `IngAproxPorMes`          VARCHAR(10)     NOT NULL DEFAULT ''           COMMENT 'Ing1=menos20,000, Ing2=20,001-50,000, Ing3=50,001-100,000, Ing4=mayor100,000.',
  `EmpresaID`               INT(11)         NOT NULL DEFAULT '0'          COMMENT 'Parámetro de auditoría ID de la empresa.',
  `Usuario`                 INT(11)         NOT NULL DEFAULT '0'          COMMENT 'Parámetro de auditoría ID del usuario.',
  `FechaActual`             DATETIME        NOT NULL DEFAULT '1900-01-01' COMMENT 'Parámetro de auditoría fecha actual.',
  `DireccionIP`             VARCHAR(15)     NOT NULL DEFAULT ''           COMMENT 'Parámetro de auditoría direccion IP.',
  `ProgramaID`              VARCHAR(50)     NOT NULL DEFAULT ''           COMMENT 'Parámetro de auditoría programa.',
  `Sucursal`                INT(11)         NOT NULL DEFAULT '0'          COMMENT 'Parámetro de auditoría ID de la sucursal.',
  `NumTransaccion`          BIGINT(20)      NOT NULL DEFAULT '0'          COMMENT 'Parámetro de auditoría numero de transaccion.',
  PRIMARY KEY (`UsuarioServicioID`, `NumTransaccionAct`),
  KEY `INDEX_HISCONOCIMIENTOUSUSERV_1` (`FuncionID`)
) ENGINE = InnoDB DEFAULT CHARSET = latin1 COMMENT = 'Tab: Tabla historica de las modificaciones de los registros de la tabla CONOCIMIENTOUSUSERVA.'$$