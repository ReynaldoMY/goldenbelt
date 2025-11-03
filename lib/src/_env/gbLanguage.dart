class gbLanguage {

  String lang = 'ES';
  Map<String, dynamic> keyword = {};

  final Map<String, Map<String, dynamic>> gblangKeywords =
  {
    'lang_gb_general': { 'ES': 'General', 'EN': 'General'},

    'lang_gb_user': { 'ES': 'Usuario', 'EN': 'User'},
    'lang_gb_pass': { 'ES': 'Contraseña', 'EN': 'Password'},
    'lang_gb_connect': { 'ES': 'Conectar', 'EN': 'Connect'},

    'lang_gb_process': { 'ES': 'Proceso', 'EN': 'Process'},
    'lang_gb_process_p': { 'ES': 'Procesos', 'EN': 'Processes'},
    'lang_gb_position': { 'ES': 'Posición', 'EN': 'Position'},
    'lang_gb_position_p': { 'ES': 'Posiciones', 'EN': 'Positions'},
    'lang_gb_document': { 'ES': 'Documento', 'EN': 'Document'},
    'lang_gb_document_p': { 'ES': 'Documentos', 'EN': 'Documents'},
    'lang_gb_policy': { 'ES': 'Política', 'EN': 'Policy'},
    'lang_gb_policy_p': { 'ES': 'Políticas', 'EN': 'Policies'},
    'lang_gb_course': { 'ES': 'Curso', 'EN': 'Course'},
    'lang_gb_course_p': { 'ES': 'Cursos', 'EN': 'Courses'},
    'lang_gb_request': { 'ES': 'Tarea', 'EN': 'Request'},
    'lang_gb_request_p': { 'ES': 'Tareas', 'EN': 'Requests'},

    'lang_gb_menu_home': { 'ES': 'Inicio', 'EN': 'Home'},
    'lang_gb_menu_groups': { 'ES': 'Grupos', 'EN': 'Groups'},
    'lang_gb_menu_settings': { 'ES': 'Configuración', 'EN': 'Settings'},
    'lang_gb_menu_inbox': { 'ES': 'Bandeja', 'EN': 'Inbox'},

    'lang_gb_version_status_edt': {
      'ES': 'Pendiente de Edición',
      'EN': 'Pending Edition'
    },
    'lang_gb_version_status_rev': {
      'ES': 'Pendiente de Revisión',
      'EN': 'Pending Revision'
    },
    'lang_gb_version_status_apr': {
      'ES': 'Pendiente de Aprobación',
      'EN': 'Pending Approval'
    },
    'lang_gb_version_status_val': {
      'ES': 'Pendiente de Validación',
      'EN': 'Pending Validation'
    },
    'lang_gb_version_status_fnd': {
      'ES': 'Oportunidades de Mejora',
      'EN': 'Findings'
    },
    'lang_gb_version_status_mrq': {
      'ES': 'Tareas Pendientes',
      'EN': 'Pending Requests'
    },

    'lang_gb_error_login': {
      'ES': 'Error en la Conexión',
      'EN': 'Connection Error'
    },
    'lang_gb_error_bad_userpass': {
      'ES': 'Credencial Inválida',
      'EN': 'Invalid Credential'
    },
    'lang_gb_error_empty_userpass': {
      'ES': 'Campos Vacíos',
      'EN': 'Empty Fields'
    },
    'lang_gb_error_bad_setup_userpass': {
      'ES': 'Usuario no configurado',
      'EN': 'User don´t setup'
    },
    'lang_gb_error_version_obsolete': {
      'ES': 'Existe una nueva versión de la aplicación. Por favor, actualicela',
      'EN': 'It exists a new app versión. Please, download it.'
    },
    'lang_gb_question': {'ES': 'Pregunta', 'EN': 'Question'},
    'lang_gb_send_answer': {'ES': 'Enviar respuesta', 'EN': 'Send answer'},

    'lang_gb_approval': {'ES': 'Aprobar', 'EN': 'Approval'},
    'lang_gb_deny': {'ES': 'Rechazar', 'EN': 'Deny'},

    'lang_gb_save': {'ES': 'Salvar', 'EN': 'Save'},
    'lang_gb_send': {'ES': 'Enviar', 'EN': 'Send'},
    'lang_gb_confirm': {'ES': 'Confirmar', 'EN': 'Confirm'},
    'lang_gb_search': {'ES': 'Buscar', 'EN': 'Search'},

    'lang_gb_without_information': {
      'ES': 'Sin Información',
      'EN': 'Without Information'
    },

    'lang_gb_course_status_pending': {'ES': 'Pendiente', 'EN': 'Pending'},
    'lang_gb_course_status_started': {'ES': 'Iniciado', 'EN': 'Started'},
    'lang_gb_course_status_finished': {'ES': 'Finalizado', 'EN': 'Finished'},
    'lang_gb_course_status_sent': {'ES': 'Enviado', 'EN': 'Sent'},

    'lang_gb_upload_file': {'ES':'Subir Archivo', 'EN':'Upload File'},
    'lang_gb_upload_image': {'ES':'Subir Imagen', 'EN':'Upload Image'},


    'lang_gb_language': {'ES':'Lenguaje', 'EN':'Language'},
    'lang_gb_company': {'ES':'Compañía', 'EN':'Company'},
    'lang_gb_workspace': {'ES':'Entorno de Trabajo', 'EN':'Workspace'},
    'lang_gb_change_environment': {'ES':'Cambiar Entorno', 'EN':'Change Environment'},
    'lang_gb_close_session': {'ES':'Cerrar Sesión', 'EN':'Close Session'},

    'lang_gb_file_name': {'ES':'Nombre del Archivo', 'EN':'File Name'},
    'lang_gb_file_size': {'ES':'Tamaño del Archivo', 'EN':'File Size'},
    'lang_gb_file_extension': {'ES':'Extensión', 'EN':'File Extension'},
    'lang_gb_file_download': {'ES':'Descargar Archivo', 'EN':'Download File'},
    'lang_gb_file_open': {'ES':'Abrir Archivo', 'EN':'Open File'},

    'lang_gb_file_attachment': {'ES':'Archivo Adjunto', 'EN':'Attachment File'},
    'lang_gb_file_view': {'ES':'Visualizar Archivo', 'EN':'View File'},
  };

  gbLanguage()
  {
    this.lang = 'ES';
    setLanguage(this.lang);
  }

  // Se define el Lenguaje del Entorno.
  setLanguage(String lang)
  {
      this.lang = lang;

      gblangKeywords.forEach((key, value) {
      this.keyword[key] = value[lang];
    });
  }

  // Se valida si es que es un Keyword de GB.
  String gbValidate(String label)
  {
    if (label.length > 7 && label.substring(0, 7) == 'lang_gb' &&  this.keyword[label] != null)
    {
      return this.keyword[label];
    }

    return label;
  }

}
