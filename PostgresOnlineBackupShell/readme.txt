#################################################
#   PostgresOnlineBackupShell
#################################################

No. Date        Author
---------------------------------------------
  1 2013/05/21  Nogami Yasumasa

�y�T�v�z
doOnlineBackup.sh��PostgreSQL�T�[�o�̃I�����C���o�b�N�A�b�v���擾����V�F���X
�N���v�g�ł���B

�y�ݒ�t�@�C���z
�X�N���v�g�����s����ɂ́Aconf_online_backup.sh�ɕK�v�ȃp�����[�^�ݒ���s���K
�v������B
LOG_DIR                 |�C��   |�{�X�N���v�g�̎��s���O�t�@�C���̏o�͐�f�B���N�g��
LOG_FILE                |��     |�{�X�N���v�g�̎��s���O�t�@�C������LOG_DIR���
�肵���ꍇ�K�{
PG_DATA                 |�K�{   |�f�[�^�x�[�X�N���X�^�f�B���N�g��
BACKUP_RESERVED_DIR     |�K�{   |�o�b�N�A�b�v�̎擾��
ARCHIVE_WAL_DIR         |�K�{   |�A�[�J�C�uWAL���O�̏o�͐�f�B���N�g��
