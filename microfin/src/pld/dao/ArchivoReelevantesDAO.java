package pld.dao;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.transaction.support.TransactionTemplate;

import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.Arrays;
import java.util.List;

import org.springframework.jdbc.core.RowMapper;

import pld.bean.ArchivoReelevantesBean;
import pld.bean.ReporteReelevantesBean;
import pld.bean.ReportesSITIBean;

import general.dao.BaseDAO;
import herramientas.Constantes;
import herramientas.Utileria;

public class ArchivoReelevantesDAO extends BaseDAO {

	public ArchivoReelevantesDAO(){
		super();
	}

	/**
	 * Lista las operaciones relevantes a reportar. Reporte formato SITI.
	 * @param reporteReelevantesBean : Clase bean con los parámetros de entrada al SP-PLDCNBVOPEREELCON.
	 * @param consulta : Número de consulta para listar.
	 * @return List Lista de Operaciones a Reportar.
	 * @author avelasco
	 */
	public List OpeReelevantes(ReporteReelevantesBean reporteReelevantesBean, int consulta, long numTransaccion){
		String query = "call PLDCNBVOPEREELCON(?,?,?,?,?,	?,?,?,?,?,	?);";
		Object[] parametros = { 
				Constantes.ENTERO_CERO,
				reporteReelevantesBean.getPeriodoFin(),
				reporteReelevantesBean.getOperaciones(),
				Utileria.convierteEntero(reporteReelevantesBean.getTipoReporte()),
				consulta,					 
				Constantes.ENTERO_CERO,
				
				Constantes.FECHA_VACIA,
				Constantes.STRING_VACIO,
				"ArchivoReelevantesDAO.OpeReelevantes",
				Constantes.ENTERO_CERO,
				numTransaccion
		};
		loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call PLDCNBVOPEREELCON(" + Arrays.toString(parametros) + ")");
		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
			public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {

				ArchivoReelevantesBean reelevantesBean = new ArchivoReelevantesBean();

				reelevantesBean.setOperaRelevante(resultSet.getString("OperaRelevante"));

				return reelevantesBean;
			}
		});

		return matches;
	}

	/**
	 * Lista las operaciones relevantes a reportar. Reporte en Excel.
	 * @param reporteReelevantesBean : Clase bean con los parámetros de entrada al SP-PLDCNBVOPEREELCON.
	 * @param consulta : Número de consulta para listar.
	 * @return List Lista de Operaciones a Reportar.
	 * @author avelasco
	 */
	public List OpeReelevantesExcel(ReportesSITIBean reporteReelevantesBean, int consulta, long numTransaccion){
		String query = "call PLDCNBVOPEREELCON(?,?,?,?,?,	?,?,?,?,?,	?);";
		Object[] parametros = {
				Constantes.ENTERO_CERO,
				reporteReelevantesBean.getPeriodoFin(),
				reporteReelevantesBean.getOperaciones(),
				Utileria.convierteEntero(reporteReelevantesBean.getTipoReporte()),
				consulta,
				Constantes.ENTERO_CERO,
				
				Constantes.FECHA_VACIA,
				Constantes.STRING_VACIO,
				"ArchivoReelevantesDAO.OpeReelevantes",
				Constantes.ENTERO_CERO,
				numTransaccion
		};
		loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call PLDCNBVOPEREELCON(" + Arrays.toString(parametros) + ");");
		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
			public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {

				ReportesSITIBean reelevantesBean = new ReportesSITIBean();
				reelevantesBean.setTipoReporte(resultSet.getString("TipoReporte"));
				reelevantesBean.setPeriodoReporte(resultSet.getString("PeriodoReporte"));
				reelevantesBean.setFolio(resultSet.getString("Folio"));
				reelevantesBean.setClaveOrgSupervisor(resultSet.getString("ClaveOrgSupervisor"));
				reelevantesBean.setClaveEntCasFim(resultSet.getString("ClaveEntCasFim"));
				reelevantesBean.setLocalidadSuc(resultSet.getString("LocalidadSuc"));
				reelevantesBean.setSucursalID(resultSet.getString("Sucursal"));
				reelevantesBean.setTipoOperacionID(resultSet.getString("TipoOperacionID"));
				reelevantesBean.setInstrumentMonID(resultSet.getString("InstrumentMonID"));
				reelevantesBean.setCuentaAhoID(resultSet.getString("CuentaAhoID"));
				reelevantesBean.setMonto(resultSet.getString("Monto"));
				reelevantesBean.setClaveMoneda(resultSet.getString("ClaveMoneda"));
				reelevantesBean.setFechaOpe(resultSet.getString("FechaOpe"));
				reelevantesBean.setFechaDeteccion(resultSet.getString("FechaDeteccion"));
				reelevantesBean.setNacionalidad(resultSet.getString("Nacionalidad"));
				reelevantesBean.setTipoPersona(resultSet.getString("TipoPersona"));
				reelevantesBean.setRazonSocial(resultSet.getString("RazonSocial"));
				reelevantesBean.setNombre(resultSet.getString("Nombre"));
				reelevantesBean.setApellidoPat(resultSet.getString("ApellidoPat"));
				reelevantesBean.setApellidoMat(resultSet.getString("ApellidoMat"));
				reelevantesBean.setRFC(resultSet.getString("RFC"));
				reelevantesBean.setCURP(resultSet.getString("CURP"));
				reelevantesBean.setFechaNac(resultSet.getString("FechaNac"));
				reelevantesBean.setDomicilio(resultSet.getString("Domicilio"));
				reelevantesBean.setColonia(resultSet.getString("Colonia"));
				reelevantesBean.setLocalidad(resultSet.getString("Localidad"));
				reelevantesBean.setTelefono(resultSet.getString("Telefono"));
				reelevantesBean.setActEconomica(resultSet.getString("ActEconomica"));
				reelevantesBean.setNomApoderado(resultSet.getString("NomApoderado"));
				reelevantesBean.setApPatApoderado(resultSet.getString("ApPatApoderado"));
				reelevantesBean.setApMatApoderado(resultSet.getString("ApMatApoderado"));
				reelevantesBean.setRFCApoderado(resultSet.getString("RFCApoderado"));
				reelevantesBean.setCURPApoderado(resultSet.getString("CURPApoderado"));
				reelevantesBean.setCtaRelacionadoID(resultSet.getString("CtaRelacionadoID"));
				reelevantesBean.setCuenAhoRelacionado(resultSet.getString("CuenAhoRelacionado"));
				reelevantesBean.setClaveSujeto(resultSet.getString("ClaveSujeto"));
				reelevantesBean.setNomTitular(resultSet.getString("NomTitular"));
				reelevantesBean.setApPatTitular(resultSet.getString("ApPatTitular"));
				reelevantesBean.setApMatTitular(resultSet.getString("ApMatTitular"));
				reelevantesBean.setDesOperacion(resultSet.getString("DesOperacion"));
				reelevantesBean.setRazones(resultSet.getString("Razones"));
				reelevantesBean.setClaveCNBV(resultSet.getString("ClaveCNBV"));
				return reelevantesBean;
			}
		});
		return matches;
	}
	
	public long getNumTransaccion(){
		return transaccionDAO.generaNumeroTransaccionOut();
	}
}