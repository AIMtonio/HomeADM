package pld.dao;

import general.dao.BaseDAO;
import herramientas.Constantes;
import herramientas.Utileria;

import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.Arrays;
import java.util.List;

import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.jdbc.core.RowMapper;

import pld.bean.NivelRiesgoClienteBean;

public class NivelRiesgoClienteDAO extends BaseDAO{

	public NivelRiesgoClienteDAO(){
		super();
	}


	public List listaInstrumentos(NivelRiesgoClienteBean nivelRiesgoClienteBean,int tipoLista ){
		//Query con el Store Procedure
		String query = "call PLDEVALUAPROCESOENCLIS(?,?,?,?,?,	?,?,?,?,?);";
		Object[] parametros = {	
				Utileria.convierteLong(nivelRiesgoClienteBean.getClienteID()),
				nivelRiesgoClienteBean.getTipoProceso(),
				tipoLista,
				parametrosAuditoriaBean.getEmpresaID(),
				parametrosAuditoriaBean.getUsuario(),
				parametrosAuditoriaBean.getFecha(),
				parametrosAuditoriaBean.getDireccionIP(),
				"NivelRiesgoClienteDAO.listaInstrumentos",
				parametrosAuditoriaBean.getSucursal(),
				Constantes.ENTERO_CERO};

		loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call  PLDEVALUAPROCESOENCLIS(" + Arrays.toString(parametros) +")");

		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
			public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
				NivelRiesgoClienteBean beanInstrumento = new NivelRiesgoClienteBean();	
				beanInstrumento.setOperProcesoID(resultSet.getString("OperProcesoID"));
				return beanInstrumento;	
			}
		});

		return matches;
	}

	public List consultaNivelRiesgoPLD(NivelRiesgoClienteBean nivelRiesgoClienteBean, int tipoConsulta) {
		transaccionDAO.generaNumeroTransaccion();
		//Query con el Store Procedure
		String query = "call NIVELRIESGOPLDCON(?,?,?,?,?,	?,?,?,?,?, ?);";
		Object[] parametros = {
				Utileria.convierteLong(nivelRiesgoClienteBean.getClienteID()),
				nivelRiesgoClienteBean.getTipoProceso(),
				Utileria.convierteLong(nivelRiesgoClienteBean.getOperProcesoID()),
				tipoConsulta,
				parametrosAuditoriaBean.getEmpresaID(),
				
				parametrosAuditoriaBean.getUsuario(),
				parametrosAuditoriaBean.getFecha(),
				parametrosAuditoriaBean.getDireccionIP(),
				"NivelRiesgoClienteDAO.consultaPrincipal",
				parametrosAuditoriaBean.getSucursal(),
				
				parametrosAuditoriaBean.getNumeroTransaccion()
		};

		loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call NIVELRIESGOPLDCON(" + Arrays.toString(parametros) +")");

		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
			public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
				NivelRiesgoClienteBean beanRiesgo = new NivelRiesgoClienteBean();		
				beanRiesgo.setConceptoMatrizID(resultSet.getString("ConceptoMatrizID"));
				beanRiesgo.setConcepto(resultSet.getString("Concepto"));
				beanRiesgo.setDescripcion(resultSet.getString("Descripcion"));
				beanRiesgo.setPuntajeTotal(resultSet.getString("PonderadoMatriz"));
				beanRiesgo.setLimiteValida(resultSet.getString("Limite"));
				beanRiesgo.setCumple(resultSet.getString("CumpleCriterio"));
				beanRiesgo.setPuntajeObtenido(resultSet.getString("PuntajeObtenido"));
				return beanRiesgo;	
			}
		});

		return matches;
	}

	public List<NivelRiesgoClienteBean> listaReporte(NivelRiesgoClienteBean nivelRiesgoRepBean, int tipoReporte) {
		transaccionDAO.generaNumeroTransaccion();
		List<NivelRiesgoClienteBean> ListaResultado = null;
		try {
			String query = "CALL NIVELRIESGOPLDREP(" 
					+ "?,?,?,?,?," 
					+ "?,?,?,?,?,"
					+ "?,?);";
			Object[] parametros = { 
					nivelRiesgoRepBean.getClienteID(),
					tipoReporte,
					nivelRiesgoRepBean.getFechaInicio(),
					nivelRiesgoRepBean.getFechaFin(),
					nivelRiesgoRepBean.getOperProcesoID(),

					parametrosAuditoriaBean.getEmpresaID(),
					parametrosAuditoriaBean.getUsuario(),
					parametrosAuditoriaBean.getFecha(),
					parametrosAuditoriaBean.getDireccionIP(),
					"NivelRiesgoClienteDAO.listaReporte",

					parametrosAuditoriaBean.getSucursal(), 
					parametrosAuditoriaBean.getNumeroTransaccion()
			};

			loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos() + "-" + "CALL NIVELRIESGOPLDREP(" + Arrays.toString(parametros).replace("[", "").replace("]", "") + ");");
			List<NivelRiesgoClienteBean> matches = ((JdbcTemplate) conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query, parametros, new RowMapper() {
				public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
					NivelRiesgoClienteBean bean = new NivelRiesgoClienteBean();
					bean.setClienteID(resultSet.getString("ClienteID"));
					bean.setNombreCliente(resultSet.getString("NombreCompleto"));
					bean.setOperProcesoID(resultSet.getString("OperProcID"));
					bean.setDescripcion(resultSet.getString("Proceso"));
					bean.setPuntajeTotal(resultSet.getString("PuntajeTotal"));
					bean.setPuntajeObtenido(resultSet.getString("PuntajeObtenido"));
					bean.setPorcentajeAnterior(resultSet.getString("PorcentajeAnterior"));
					bean.setPorcentaje(resultSet.getString("Porcentaje"));
					bean.setNivelAnterior(resultSet.getString("NivelAnterior"));
					bean.setNivelRiesgo(resultSet.getString("NivelRiesgo"));
					bean.setFechaEvaluacion(resultSet.getString("FechaEvaluacion"));
					return bean;
				}
			});
			ListaResultado = matches;
		} catch (Exception e) {
			e.printStackTrace();
			loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos() + "-" + "Error en reporte Histórico de Evaluación por Nivel de Riesgo : ", e);
		}
		return ListaResultado;
	}
	
	public long getNumeroTransaccion(){
		return transaccionDAO.generaNumeroTransaccionOut();
	}
}
