package cliente.dao;

import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.Arrays;
import java.util.List;

import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.jdbc.core.RowMapper;
import cliente.bean.CliCancelaEntregaBean;
import general.dao.BaseDAO;

public class CliCancelaEntregaDAO extends BaseDAO {

	public CliCancelaEntregaDAO() {
		super();
	}
	
	/*lista que devuelve los beneficiarios por folio de solicitud de cancelacion */
	public List listaPorFolio(CliCancelaEntregaBean cliCancelaEntregaBean, int tipoLista){
    	List listaFolio = null;
		try{
			String query = "call CLICANCELAENTREGALIS(" +
					"?,?,?,?,?, ?,?,?,?);";
			Object[] parametros = {
					cliCancelaEntregaBean.getClienteCancelaID(),
					tipoLista,
					parametrosAuditoriaBean.getEmpresaID(),
					parametrosAuditoriaBean.getUsuario(),
					parametrosAuditoriaBean.getFecha(),
						
					parametrosAuditoriaBean.getDireccionIP(),
					parametrosAuditoriaBean.getNombrePrograma(),
					parametrosAuditoriaBean.getSucursal(),
					parametrosAuditoriaBean.getNumeroTransaccion()
			};	
			loggerSAFI.info("call CLICANCELAENTREGALIS(" + Arrays.toString(parametros) +")");
		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
				public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
					CliCancelaEntregaBean cliCancelaEntregaBean = new CliCancelaEntregaBean();
					cliCancelaEntregaBean.setCliCancelaEntregaID(resultSet.getString("CliCancelaEntregaID"));
					cliCancelaEntregaBean.setNombreBeneficiario(resultSet.getString("NombreBeneficiario"));
					cliCancelaEntregaBean.setPorcentaje(resultSet.getString("Porcentaje"));
					cliCancelaEntregaBean.setEstatus(resultSet.getString("Estatus"));
					cliCancelaEntregaBean.setCantidadRecibir(resultSet.getString("CantidadRecibir"));
					cliCancelaEntregaBean.setTotalRecibir(resultSet.getString("Var_TotalRecibir"));
					cliCancelaEntregaBean.setClienteID(resultSet.getString("ClienteID"));
					cliCancelaEntregaBean.setEstatusDes(resultSet.getString("EstatusDes"));
					return cliCancelaEntregaBean;				
				}
			});
			listaFolio =  matches;
		}catch(Exception e){
			e.printStackTrace();
		}
		return listaFolio;
	}
	
	/* Lista para el grid de Beneficiarios Existentes en la Distribucion de Beneficios*/
	public List listaBeneficiariosExistentes(CliCancelaEntregaBean cliCancelaEntregaBean, int tipoLista){
			String query = "call CLICANCELAENTREGALIS(" +
					"?,?,?,?,?, ?,?,?,?);";
			Object[] parametros = {
					cliCancelaEntregaBean.getClienteCancelaID(),
					tipoLista,
					parametrosAuditoriaBean.getEmpresaID(),
					parametrosAuditoriaBean.getUsuario(),
					parametrosAuditoriaBean.getFecha(),
						
					parametrosAuditoriaBean.getDireccionIP(),
					parametrosAuditoriaBean.getNombrePrograma(),
					parametrosAuditoriaBean.getSucursal(),
					parametrosAuditoriaBean.getNumeroTransaccion()
			};	
			loggerSAFI.info("call CLICANCELAENTREGALIS(" + Arrays.toString(parametros) +")");
			List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {				public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
					CliCancelaEntregaBean cliCancelaEntregaBean = new CliCancelaEntregaBean();
					cliCancelaEntregaBean.setCliCancelaEntregaID(resultSet.getString("CliCancelaEntregaID"));
					cliCancelaEntregaBean.setNombreBeneficiario(resultSet.getString("NombreBeneficiario"));
				//	cliCancelaEntregaBean.setDescripcion(resultSet.getString("Descripcion"));
					cliCancelaEntregaBean.setCuentaAhoID(resultSet.getString("CuentaAhoID"));
				//	cliCancelaEntregaBean.setInversionID(resultSet.getString("InversionID"));
					cliCancelaEntregaBean.setPorcentaje(resultSet.getString("Porcentaje"));
					cliCancelaEntregaBean.setTotalRecibir(resultSet.getString("CantidadRecibir"));
					return cliCancelaEntregaBean;				
				}
			});
			return matches;
		}
	}

